#!/bin/bash

# Nama tmux session
SESSION="aptupdatemendem"

# Cek parameter supaya self-call tidak loop tak berujung
if [ "$1" != "exekusi" ]; then
    # Dipanggil tanpa parameter → buat tmux session dan self-call
    tmux new-session -d -s $SESSION "$0 exekusi"
    tmux attach -t $SESSION
    exit 0
fi

# ======================================================
# Bagian ini dijalankan di tmux
# ======================================================

echo "Starting apt update & upgrade..."

# Update package list
echo "Running: sudo apt update"
sudo apt update

# Upgrade packages
echo "Running: sudo apt upgrade -y"
sudo apt upgrade -y

# Hapus paket yang tidak diperlukan
echo "Running: sudo apt autoremove -y"
sudo apt autoremove -y

#echo "All done. Press enter to exit tmux."
#read -p ""