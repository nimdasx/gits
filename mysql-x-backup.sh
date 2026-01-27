#!/bin/bash

#catatan
#
#sebelumnya eksekusi ini dulu
#export MYSQL_PASSWORD="password_db"
#
#di server --skip-ssl tidak ada, hapus aja

# ====== VALIDASI PARAMETER ======
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <host> <port> <user> <database> <zip_password>"
  exit 1
fi

HOST="$1"
PORT="$2"
MYSQL_USER="$3"
DB_NAME="$4"
ZIP_PASS="$5"

# ====== VALIDASI ENV MYSQL ======
if [ -z "$MYSQL_PASSWORD" ]; then
  echo "ERROR: MYSQL_PASSWORD harus diset di environment"
  exit 1
fi

# ====== TIMESTAMP ======
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

# ====== OUTPUT DIR ======
BACKUP_DIR="./mysql-x-backup"
mkdir -p "$BACKUP_DIR"

# ====== NAMA FILE ======
STRUCT_FILE="${BACKUP_DIR}/${HOST}-${DB_NAME}-${TIMESTAMP}-structure.sql"
DATA_FILE="${BACKUP_DIR}/${HOST}-${DB_NAME}-${TIMESTAMP}-data.sql"
ZIP_FILE="${BACKUP_DIR}/${HOST}-${DB_NAME}-${TIMESTAMP}.sql.zip"

# ====== BACKUP STRUCTURE ======
mysqldump --no-defaults --skip-ssl \
  -h "$HOST" \
  -P "$PORT" \
  -u "$MYSQL_USER" \
  -p"$MYSQL_PASSWORD" \
  --no-data \
  --routines \
  --triggers \
  --events \
  --single-transaction \
  "$DB_NAME" > "$STRUCT_FILE"

if [ $? -ne 0 ]; then
  echo "ERROR: Backup structure gagal"
  rm -f "$STRUCT_FILE"
  exit 1
fi

# ====== BACKUP DATA ======
mysqldump --no-defaults --skip-ssl \
  -h "$HOST" \
  -P "$PORT" \
  -u "$MYSQL_USER" \
  -p"$MYSQL_PASSWORD" \
  --no-create-info \
  --skip-triggers \
  --single-transaction \
  --ignore-table="${DB_NAME}.cr_log_akses" \
  --ignore-table="${DB_NAME}.cr_log_error" \
  --ignore-table="${DB_NAME}.cr_log_out" \
  "$DB_NAME" > "$DATA_FILE"

if [ $? -ne 0 ]; then
  echo "ERROR: Backup data gagal"
  rm -f "$STRUCT_FILE" "$DATA_FILE"
  exit 1
fi

# ====== ZIP DENGAN PASSWORD ======
zip -P "$ZIP_PASS" "$ZIP_FILE" "$STRUCT_FILE" "$DATA_FILE" > /dev/null

if [ $? -ne 0 ]; then
  echo "ERROR: Gagal membuat zip"
  rm -f "$STRUCT_FILE" "$DATA_FILE"
  exit 1
fi

# ====== BERSIHKAN FILE SQL ======
rm -f "$STRUCT_FILE" "$DATA_FILE"

echo "✅ Backup berhasil:"
echo "📦 $ZIP_FILE"
