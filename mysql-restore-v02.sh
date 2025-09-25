#!/bin/bash

# Minta input dari user
read -p "Nama file SQL (bisa .sql atau .sql.gz): " nama_file
read -p "Nama database baru: " nama_db

# Cek file ada atau nggak
if [[ ! -f "$nama_file" ]]; then
  echo "❌ File '$nama_file' tidak ditemukan."
  exit 1
fi

# Cek apakah database sudah ada
db_exists=$(mysql --defaults-extra-file=mylogin.cnf -Nse "SHOW DATABASES LIKE '${nama_db}'")

if [[ "$db_exists" == "$nama_db" ]]; then
  echo "❌ Database '${nama_db}' sudah ada, restore dibatalkan."
  exit 1
fi

# Bikin database baru
mysql --defaults-extra-file=mylogin.cnf -e "CREATE DATABASE \`${nama_db}\`"
if [[ $? -ne 0 ]]; then
  echo "❌ Gagal membuat database '${nama_db}'."
  exit 1
fi

# Tentukan perintah restore (gzip atau biasa)
if [[ "$nama_file" == *.gz ]]; then
  echo "▶️  Detected compressed file, extracting & restoring..."
  pv "$nama_file" | gunzip -c | mysql --defaults-extra-file=mylogin.cnf "$nama_db"
else
  echo "▶️  Restoring from plain SQL file..."
  pv "$nama_file" | mysql --defaults-extra-file=mylogin.cnf "$nama_db"
fi

echo "✅ Restore selesai ke database '${nama_db}'!"
