#!/bin/bash

#sebelumnya eksekusi ini dulu
#export MYSQL_USER="username_db"
#export MYSQL_PASSWORD="password_db"


# ====== VALIDASI PARAMETER ======
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <host> <port> <database> <zip_password>"
  exit 1
fi

HOST="$1"
PORT="$2"
DB_NAME="$3"
ZIP_PASS="$4"

# ====== VALIDASI ENV MYSQL ======
if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "ERROR: MYSQL_USER dan MYSQL_PASSWORD harus diset di environment"
  exit 1
fi

# ====== TIMESTAMP ======
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

# ====== NAMA FILE ======
STRUCT_FILE="${HOST}-${DB_NAME}-${TIMESTAMP}-structure.sql"
DATA_FILE="${HOST}-${DB_NAME}-${TIMESTAMP}-data.sql"
ZIP_FILE="${HOST}-${DB_NAME}-${TIMESTAMP}.sql.zip"

# ====== BACKUP STRUCTURE ======
mysqldump \
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
mysqldump \
  -h "$HOST" \
  -P "$PORT" \
  -u "$MYSQL_USER" \
  -p"$MYSQL_PASSWORD" \
  --no-create-info \
  --skip-triggers \
  --single-transaction \
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
