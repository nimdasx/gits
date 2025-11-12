#!/bin/bash

# Pastikan script dijalankan dengan root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan script ini sebagai root (sudo)."
  exit 1
fi

# Pastikan ada argumen hostname baru
if [ -z "$1" ]; then
  echo "Usage: $0 <nama-hostname-baru>"
  exit 1
fi

NEW_HOSTNAME="$1"
CURRENT_HOSTNAME=$(hostnamectl --static)

echo "Hostname lama: $CURRENT_HOSTNAME"
echo "Hostname baru: $NEW_HOSTNAME"
echo

# 1. Ganti hostname dengan hostnamectl
echo "[1/2] Mengubah hostname..."
hostnamectl set-hostname "$NEW_HOSTNAME"

# 2. Update file /etc/hosts
echo "[2/2] Memperbarui /etc/hosts..."

# Backup file /etc/hosts sebelum diubah
cp /etc/hosts /etc/hosts.bak.$(date +%F_%T)

# Ganti semua kemunculan hostname lama dengan yang baru
sed -i "s/\b$CURRENT_HOSTNAME\b/$NEW_HOSTNAME/g" /etc/hosts

echo
echo "Selesai! Hostname telah diubah menjadi: $NEW_HOSTNAME"
echo "Backup /etc/hosts tersimpan di: /etc/hosts.bak.$(date +%F_%T)"
echo
echo "Disarankan untuk logout/login ulang atau reboot agar perubahan sepenuhnya berlaku."
