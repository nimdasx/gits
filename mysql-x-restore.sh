#!/bin/bash

#sebelumnya eksekusi ini dulu
#export MYSQL_USER="username_db"
#export MYSQL_PASSWORD="password_db"

# ====== VALIDASI PARAMETER ======
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <host> <port> <database> <zip_password> <backup_zip>"
  exit 1
fi

HOST="$1"
PORT="$2"
DB_NAME="$3"
ZIP_PASS="$4"
ZIP_FILE="$5"

# ====== VALIDASI ENV MYSQL ======
if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "ERROR: MYSQL_USER dan MYSQL_PASSWORD harus diset di environment"
  exit 1
fi

# ====== VALIDASI FILE ZIP ======
if [ ! -f "$ZIP_FILE" ]; then
  echo "ERROR: File backup tidak ditemukan: $ZIP_FILE"
  exit 1
fi

# ====== WORKDIR TEMP ======
WORKDIR=$(mktemp -d)

# ====== UNZIP ======
unzip -P "$ZIP_PASS" "$ZIP_FILE" -d "$WORKDIR" > /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: Gagal unzip (password salah atau file corrupt)"
  rm -rf "$WORKDIR"
  exit 1
fi

STRUCT_FILE=$(ls "$WORKDIR"/*-structure.sql 2>/dev/null)
DATA_FILE=$(ls "$WORKDIR"/*-data.sql 2>/dev/null)

if [ -z "$STRUCT_FILE" ] || [ -z "$DATA_FILE" ]; then
  echo "ERROR: File structure/data tidak ditemukan di zip"
  rm -rf "$WORKDIR"
  exit 1
fi

# ====== RESTORE STRUCTURE ======
echo "🔧 Restore structure..."
mysql \
  -h "$HOST" \
  -P "$PORT" \
  -u "$MYSQL_USER" \
  -p"$MYSQL_PASSWORD" \
  "$DB_NAME" < "$STRUCT_FILE"

if [ $? -ne 0 ]; then
  echo "ERROR: Restore structure gagal"
  rm -rf "$WORKDIR"
  exit 1
fi

# ====== RESTORE DATA ======
echo "📦 Restore data..."
mysql \
  -h "$HOST" \
  -P "$PORT" \
  -u "$MYSQL_USER" \
  -p"$MYSQL_PASSWORD" \
  "$DB_NAME" < "$DATA_FILE"

if [ $? -ne 0 ]; then
  echo "ERROR: Restore data gagal"
  rm -rf "$WORKDIR"
  exit 1
fi

# ====== BERSIHKAN ======
rm -rf "$WORKDIR"

echo "✅ Restore database berhasil: $DB_NAME"
