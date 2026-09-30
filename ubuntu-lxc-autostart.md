# Autostart Rootless LXC dengan Systemd User Service

Dokumentasi ini menjelaskan cara membuat container **rootless LXC** otomatis berjalan ketika Ubuntu VM melakukan boot.

## Environment

* Host VM: `destiny`
* OS: Ubuntu 26.04 LTS
* LXC container: `destiny-lxc`
* LXC mode: rootless / unprivileged
* User: `sfx`
* LXC storage:

```text
/home/sfx/.local/share/lxc
```

* Systemd user service: `systemd --user`

---

## 1. Pastikan LXC Berjalan sebagai User

Cek LXC path:

```bash
lxc-config lxc.lxcpath
```

Expected:

```text
/home/sfx/.local/share/lxc
```

Cek container:

```bash
lxc-info -n destiny-lxc
```

Contoh:

```text
Name:           destiny-lxc
State:          RUNNING
PID:            3386
IP:             10.0.3.159
```

---

## 2. Aktifkan systemd Linger untuk User

Karena LXC dijalankan sebagai user `sfx`, systemd user manager harus tetap aktif walaupun user belum login.

Aktifkan linger:

```bash
sudo loginctl enable-linger sfx
```

Verifikasi:

```bash
loginctl show-user sfx -p Linger
```

Expected:

```text
Linger=yes
```

Dengan `Linger=yes`, systemd user manager untuk `sfx` dapat berjalan sejak boot tanpa menunggu user melakukan login.

---

## 3. Buat Direktori Systemd User Service

Buat direktori:

```bash
mkdir -p ~/.config/systemd/user
```

---

## 4. Buat Service untuk Container

Buat file:

```bash
nano ~/.config/systemd/user/destiny-lxc.service
```

Isi:

```ini
[Unit]
Description=Start LXC container destiny-lxc
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/lxc-start -n destiny-lxc
ExecStop=/usr/bin/lxc-stop -n destiny-lxc

[Install]
WantedBy=default.target
```

### Penjelasan

`Type=oneshot`

Service menjalankan perintah sekali untuk melakukan start container.

`RemainAfterExit=yes`

Systemd menganggap service tetap aktif setelah `lxc-start` selesai menjalankan proses start container.

`ExecStart`

Menjalankan container:

```bash
/usr/bin/lxc-start -n destiny-lxc
```

`ExecStop`

Menghentikan container ketika service dihentikan:

```bash
/usr/bin/lxc-stop -n destiny-lxc
```

`WantedBy=default.target`

Membuat service dapat dijalankan otomatis oleh systemd user ketika user manager `sfx` aktif.

---

## 5. Reload Systemd User

Setelah membuat service:

```bash
systemctl --user daemon-reload
```

---

## 6. Enable Service

Aktifkan service agar otomatis dijalankan:

```bash
systemctl --user enable destiny-lxc.service
```

Verifikasi:

```bash
systemctl --user status destiny-lxc.service
```

---

## 7. Test Start Manual

Sebelum melakukan reboot, test service secara manual.

Jika container sedang STOPPED:

```bash
lxc-info -n destiny-lxc
```

Expected:

```text
State: STOPPED
```

Start melalui systemd:

```bash
systemctl --user start destiny-lxc.service
```

Kemudian cek:

```bash
lxc-info -n destiny-lxc
```

Expected:

```text
State: RUNNING
```

Bisa juga cek service:

```bash
systemctl --user status destiny-lxc.service
```

---

## 8. Test Autostart Setelah Reboot

Setelah service berhasil dijalankan secara manual, reboot VM:

```bash
sudo reboot
```

Setelah VM kembali hidup, login sebagai `sfx`.

Jangan menjalankan `lxc-start` secara manual.

Langsung cek:

```bash
lxc-info -n destiny-lxc
```

Expected:

```text
Name:           destiny-lxc
State:          RUNNING
```

Jika `State: RUNNING`, maka autostart berhasil.

---

# 9. Verifikasi Systemd

Cek apakah service aktif:

```bash
systemctl --user status destiny-lxc.service
```

Cek apakah service sudah enabled:

```bash
systemctl --user is-enabled destiny-lxc.service
```

Expected:

```text
enabled
```

Cek seluruh service user:

```bash
systemctl --user list-unit-files
```

---

# 10. Troubleshooting

Jika container tidak otomatis start setelah reboot, periksa:

### Cek Linger

```bash
loginctl show-user sfx -p Linger
```

Harus:

```text
Linger=yes
```

### Cek service

```bash
systemctl --user status destiny-lxc.service
```

### Cek log service

```bash
journalctl --user -u destiny-lxc.service
```

Untuk boot terakhir:

```bash
journalctl --user -b -u destiny-lxc.service
```

### Cek status container

```bash
lxc-info -n destiny-lxc
```

### Cek konfigurasi LXC

```bash
lxc-info -n destiny-lxc
```

Dan pastikan container dapat dijalankan manual:

```bash
lxc-start -n destiny-lxc
```

Jika manual start gagal, masalahnya bukan pada systemd autostart tetapi pada konfigurasi atau runtime LXC.

---

# 11. Opsional: Menghapus LXC Native Autostart

Jika sebelumnya konfigurasi container memiliki:

```ini
lxc.start.auto = 1
lxc.start.delay = 5
lxc.start.order = 10
```

dan autostart sekarang sepenuhnya ditangani oleh systemd, konfigurasi tersebut dapat dihapus agar hanya ada satu mekanisme autostart.

Edit:

```bash
nano ~/.local/share/lxc/destiny-lxc/config
```

Hapus:

```ini
lxc.start.auto = 1
lxc.start.delay = 5
lxc.start.order = 10
```

Kemudian:

```bash
systemctl --user daemon-reload
```

Systemd user service tetap menjadi mekanisme autostart:

```text
VM boot
   │
   ▼
systemd
   │
   ▼
systemd user manager (sfx)
   │
   ▼
destiny-lxc.service
   │
   ▼
lxc-start
   │
   ▼
destiny-lxc
```

---

# 12. Perintah Ringkas

Jika seluruh konfigurasi LXC sudah selesai dan hanya ingin membuat autostart:

```bash
sudo loginctl enable-linger sfx

mkdir -p ~/.config/systemd/user

nano ~/.config/systemd/user/destiny-lxc.service
```

Isi:

```ini
[Unit]
Description=Start LXC container destiny-lxc
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/lxc-start -n destiny-lxc
ExecStop=/usr/bin/lxc-stop -n destiny-lxc

[Install]
WantedBy=default.target
```

Kemudian:

```bash
systemctl --user daemon-reload
systemctl --user enable destiny-lxc.service
systemctl --user start destiny-lxc.service
```

Verifikasi:

```bash
lxc-info -n destiny-lxc
```

Expected:

```text
State: RUNNING
```

Kemudian test:

```bash
sudo reboot
```

Setelah boot:

```bash
lxc-info -n destiny-lxc
```

Expected:

```text
State: RUNNING
```

Jika demikian, rootless LXC `destiny-lxc` sudah otomatis start setiap kali VM `destiny` boot.
