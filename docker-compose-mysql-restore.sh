#!/bin/sh

# ==========================
# VALIDASI PARAMETER
# ==========================
if [ $# -ne 2 ]; then
  echo "❌ Usage: $0 <nama_database> <file_backup.tar.gz>"
  echo "👉 Contoh: $0 dbku backup.sql.tar.gz"
  exit 1
fi

DB_NAME="$1"
BACKUP_FILE="$2"

# ==========================
# KONFIGURASI
# ==========================
SERVICE_NAME="mariadbx"
DB_USER="root"
DB_PASS="xxx"

# ==========================
# VALIDASI FILE
# ==========================
if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ File backup tidak ditemukan: $BACKUP_FILE"
  exit 1
fi

echo "📦 Backup file : $BACKUP_FILE"
echo "🗄️  Database    : $DB_NAME"

# ==========================
# CEK DATABASE EXIST
# ==========================
echo "🔍 Mengecek apakah database sudah ada..."

DB_EXIST=$(docker compose exec -T "$SERVICE_NAME" \
mariadb -u"$DB_USER" -p"$DB_PASS" \
-e "SHOW DATABASES LIKE '$DB_NAME';" | tail -n +2)

if [ -n "$DB_EXIST" ]; then
  echo "❌ Database '$DB_NAME' SUDAH ADA"
  echo "🛑 Restore DIBATALKAN demi keamanan"
  exit 1
fi

echo "✅ Database belum ada, lanjut proses..."

# ==========================
# CREATE DATABASE
# ==========================
echo "🛠️  Membuat database..."

docker compose exec -T "$SERVICE_NAME" \
mariadb -u"$DB_USER" -p"$DB_PASS" \
-e "CREATE DATABASE \`$DB_NAME\`;"

if [ $? -ne 0 ]; then
  echo "❌ Gagal membuat database"
  exit 1
fi

# ==========================
# RESTORE DATABASE
# ==========================
echo "🚀 Restore database dimulai..."

# Pakai pv kalau tersedia
if command -v pv >/dev/null 2>&1; then
  pv "$BACKUP_FILE" | tar -xOzf - | \
  docker compose exec -T "$SERVICE_NAME" \
  mariadb -u"$DB_USER" -p"$DB_PASS" "$DB_NAME"
else
  tar -xOzf "$BACKUP_FILE" | \
  docker compose exec -T "$SERVICE_NAME" \
  mariadb -u"$DB_USER" -p"$DB_PASS" "$DB_NAME"
fi

if [ $? -eq 0 ]; then
  echo "✅ Restore database BERHASIL"
else
  echo "❌ Restore database GAGAL"
  exit 1
fi