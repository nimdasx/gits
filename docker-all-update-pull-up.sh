#!/bin/bash

# Cek parameter
if [ "$1" != "exekusi" ]; then
    # Dipanggil tanpa parameter → jalankan tmux
    SESSION="docker-update"
    tmux new-session -d -s $SESSION "$0 exekusi"
    tmux attach -t $SESSION
    exit 0
fi

# Ambil semua docker compose yang running
docker compose ls --format json | jq -r '.[] | select(.Status | test("running")) | .ConfigFiles' | while read compose_file; do
    dir=$(dirname "$compose_file")
    echo "=============================="
    echo "Processing $dir"
    cd "$dir" || { echo "Gagal masuk ke $dir"; continue; }

    # Pull image terbaru
    echo "Pulling images..."
    docker compose pull

    echo "down..."
    docker compose down

    # Up container
    echo "Starting containers..."
    docker compose up -d

    echo "Done with $dir"
done