#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="update-agent"
SCRIPT_PATH="$(readlink -f "$0")"

# -----------------------------
# DRY RUN FLAG
# -----------------------------
DRY_RUN=false
DRY_RUN_FLAG=""

if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]]; then
  DRY_RUN=true
  DRY_RUN_FLAG="--dry-run"
fi

# -----------------------------
# TMUX CONTROL
# -----------------------------
if [[ -z "${TMUX:-}" ]]; then
  if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "ERROR: tmux session '$SESSION_NAME' already exists. Abort."
    exit 1
  fi

  echo "Starting tmux session: $SESSION_NAME"
  tmux new-session -s "$SESSION_NAME" \
    "$SCRIPT_PATH $DRY_RUN_FLAG"
  exit 0
fi

# =============================
# REAL EXECUTION (inside tmux)
# =============================

echo "=== Update Beszel Agent & NetBird ==="
$DRY_RUN && echo "*** DRY-RUN MODE (no changes) ***"

SEARCH_PATHS="/opt /srv /home /root /etc"

APPS=(
  "beszel:beszel-agent.service:beszel-agent"
  "netbird:netbird.service:netbird"
)

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

run() {
  if $DRY_RUN; then
    echo "[DRY-RUN] $*"
  else
    eval "$@"
  fi
}

docker_available=false
command_exists docker && docker_available=true

find_compose() {
  local name="$1"
  find $SEARCH_PATHS -name docker-compose.yml 2>/dev/null | grep -i "$name" || true
}

update_docker() {
  local compose_file="$1"
  local dir
  dir=$(dirname "$compose_file")

  echo "-> Docker Compose: $compose_file"
  run "cd \"$dir\" && docker compose pull"
  run "cd \"$dir\" && docker compose up -d"
}

update_native() {
  local pkg="$1"
  echo "-> Native update: $pkg"
  run "sudo apt update"
  run "sudo apt install --only-upgrade \"$pkg\" -y"
}

for app in "${APPS[@]}"; do
  IFS=":" read -r name service pkg <<< "$app"

  echo ""
  echo "### $name ###"

  docker_found=false

  if [[ "$docker_available" == true ]]; then
    mapfile -t COMPOSES < <(find_compose "$name")
    if [[ ${#COMPOSES[@]} -gt 0 ]]; then
      docker_found=true
      for c in "${COMPOSES[@]}"; do
        update_docker "$c"
      done
    fi
  fi

  if [[ "$docker_found" == true ]]; then
    echo "-> Skip apt (Docker detected)"
    continue
  fi

  if systemctl list-unit-files | grep -q "^$service"; then
    update_native "$pkg"
  else
    echo "-> Tidak terdeteksi (docker / native)"
  fi
done

echo ""
echo "=== Selesai ==="

# -----------------------------
# AUTO CLOSE TMUX SESSION
# -----------------------------
sleep 5
#tmux kill-session -t "$SESSION_NAME"