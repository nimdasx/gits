#!/bin/bash

# Memeriksa apakah script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
   echo "Script ini harus dijalankan sebagai root!" >&2
   exit 1
fi

# Mendapatkan nama user yang sedang login ke sesi terminal
CURRENT_USER=$(logname 2>/dev/null)

if [[ -z "$CURRENT_USER" ]]; then
    echo "Tidak dapat mendeteksi user login. Pastikan Anda menjalankan script ini dari sesi yang valid!" >&2
    exit 1
fi

# Menambahkan rule ke sudoers untuk user saat ini
SUDOERS_FILE="/etc/sudoers.d/$CURRENT_USER"
if [[ -f $SUDOERS_FILE ]]; then
    echo "Rule sudo untuk $CURRENT_USER sudah ada."
else
    echo "$CURRENT_USER ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
    chmod 440 "$SUDOERS_FILE"
    echo "Rule sudo tanpa password telah ditambahkan untuk user $CURRENT_USER."
fi
