# Instalasi Unprivileged LXC di Ubuntu 26.04

Dokumentasi ini menjelaskan instalasi dan konfigurasi **LXC
unprivileged** pada Ubuntu 26.04, termasuk pembuatan container Ubuntu
26.04 (`resolute`), konfigurasi UID/GID mapping, AppArmor untuk nested
LXC, ACL, dan networking.

Arsitektur akhir:

``` text
Proxmox
└── Ubuntu 26.04 VM
    └── Unprivileged LXC
        └── Ubuntu 26.04
```

## 1. Install LXC dan uidmap

``` bash
sudo apt update
sudo apt install -y lxc uidmap acl
```

Verifikasi LXC:

``` bash
lxc-checkconfig
```

Pastikan fitur penting seperti `Namespaces`, `User namespace`,
`Cgroups`, `Cgroup namespace`, dan `Network namespace` berstatus
`enabled`.

Cek utilitas UID/GID mapping:

``` bash
which newuidmap
which newgidmap
```

Contoh hasil:

``` text
/usr/bin/newuidmap
/usr/bin/newgidmap
```

## 2. Konfigurasi subordinate UID/GID

Cek konfigurasi:

``` bash
cat /etc/subuid
cat /etc/subgid
```

Untuk user `sfx`, konfigurasi yang digunakan:

``` text
sfx:100000:65536
```

Jika belum ada, tambahkan:

``` bash
echo 'sfx:100000:65536' | sudo tee -a /etc/subuid
echo 'sfx:100000:65536' | sudo tee -a /etc/subgid
```

> Ganti `sfx` dengan username Linux yang akan menjalankan LXC.

Mapping tersebut membuat UID `0` di dalam container dipetakan ke UID
`100000` pada host Ubuntu, sehingga root container bukan root host.

## 3. Buat konfigurasi LXC untuk user

Buat direktori konfigurasi:

``` bash
mkdir -p ~/.config/lxc
```

Buat `~/.config/lxc/default.conf`:

``` bash
cat > ~/.config/lxc/default.conf <<'EOF'
lxc.include = /etc/lxc/default.conf
lxc.idmap = u 0 100000 65536
lxc.idmap = g 0 100000 65536
EOF
```

Verifikasi:

``` bash
cat ~/.config/lxc/default.conf
```

## 4. Buat container Ubuntu 26.04

Contoh nama container: `destiny-lxc`.

``` bash
lxc-create -n destiny-lxc -t download
```

Pilih:

``` text
Distribution: ubuntu
Release: resolute
Architecture: amd64
```

Atau langsung:

``` bash
lxc-create -n destiny-lxc -t download -- -d ubuntu -r resolute -a amd64
```

Karena dibuat sebagai user biasa tanpa `sudo`, container disimpan pada:

``` text
~/.local/share/lxc/destiny-lxc/
```

## 5. Konfigurasi AppArmor untuk nested LXC

Pada LXC yang berjalan di dalam VM, startup dapat gagal dengan error
seperti:

``` text
Permission denied - Error creating AppArmor namespace
Failed to load generated AppArmor profile
```

Edit konfigurasi container:

``` bash
vim ~/.local/share/lxc/destiny-lxc/config
```

Tambahkan:

``` text
lxc.apparmor.profile = unconfined
```

Ini hanya menonaktifkan profile AppArmor LXC untuk container tersebut;
container tetap menggunakan unprivileged UID/GID mapping.

## 6. Berikan ACL untuk rootfs container

Karena rootfs berada di bawah `/home/<user>`, UID container perlu hak
traverse pada home directory.

Untuk user `sfx`:

``` bash
sudo setfacl -m u:100000:x /home/sfx
```

Verifikasi:

``` bash
getfacl /home/sfx
```

Harus terdapat entry seperti:

``` text
user:100000:--x
```

Hak `x` pada direktori hanya memberikan kemampuan traverse, bukan hak
membaca isi direktori secara umum.

## 7. Izinkan unprivileged LXC menggunakan network bridge

Buat/edit:

``` bash
sudo vim /etc/lxc/lxc-usernet
```

Tambahkan:

``` text
sfx veth lxcbr0 10
```

Artinya user `sfx` diperbolehkan membuat maksimal 10 interface `veth`
pada bridge `lxcbr0`.

Cek bridge:

``` bash
ip link show lxcbr0
```

`NO-CARRIER` atau `state DOWN` ketika belum ada container yang terhubung
dapat terjadi meskipun interface bridge sudah `UP`.

## 8. Start container di background

Jalankan sebagai user pemilik container, **tanpa `sudo`**:

``` bash
lxc-start -n destiny-lxc
```

Atau sintaks ringkas jika didukung command yang digunakan:

``` bash
lxc-start destiny-lxc
```

Cek status:

``` bash
lxc-ls -f
```

Contoh:

``` text
NAME        STATE   AUTOSTART GROUPS IPV4         IPV6  UNPRIVILEGED
destiny-lxc RUNNING 0         -      10.0.3.159   ...   true
```

Nilai `UNPRIVILEGED=true` menunjukkan container menggunakan unprivileged
user namespace.

> Gunakan `-F` hanya untuk debugging/foreground, misalnya
> `lxc-start -n destiny-lxc -F`.

## 9. Masuk ke container

``` bash
lxc-attach destiny-lxc
```

Bentuk eksplisitnya juga bisa:

``` bash
lxc-attach -n destiny-lxc
```

Cek OS:

``` bash
cat /etc/os-release
```

Cek identity:

``` bash
id
```

Di dalam container akan terlihat `uid=0(root)`, tetapi UID tersebut
dipetakan ke subordinate UID pada host.

Cek mapping:

``` bash
cat /proc/self/uid_map
cat /proc/self/gid_map
```

Mapping yang diharapkan kurang lebih:

``` text
         0     100000      65536
```

## 10. Cek networking container

Di dalam container:

``` bash
ip addr
ip route
ping -c 3 1.1.1.1
```

Jika berhasil, container sudah memiliki konektivitas melalui `lxcbr0`.

## 11. Stop dan restart container

Keluar dari shell container:

``` bash
exit
```

Stop:

``` bash
lxc-stop destiny-lxc
```

Start kembali:

``` bash
lxc-start destiny-lxc
```

Restart:

``` bash
lxc-stop destiny-lxc && lxc-start destiny-lxc
```

## 12. Command LXC yang sering digunakan

``` bash
# Daftar container dan status
lxc-ls -f

# Start background
lxc-start destiny-lxc

# Masuk ke container
lxc-attach destiny-lxc

# Informasi container
lxc-info destiny-lxc

# Stop
lxc-stop destiny-lxc

# Debug startup di foreground
lxc-start destiny-lxc -F -l DEBUG -o /tmp/destiny-lxc.log

# Lihat debug log
tail -50 /tmp/destiny-lxc.log
```

## Troubleshooting yang ditemui

### `No uid mapping for container root`

Pastikan `/etc/subuid`, `/etc/subgid`, dan `~/.config/lxc/default.conf`
sudah dikonfigurasi seperti langkah di atas.

### `Error creating AppArmor namespace`

Tambahkan ke konfigurasi container:

``` text
lxc.apparmor.profile = unconfined
```

### `Could not access /home/<user>`

Berikan ACL traverse kepada UID root container:

``` bash
sudo setfacl -m u:100000:x /home/sfx
```

### `Failed to open /etc/lxc/lxc-usernet` / `Quota reached`

Buat `/etc/lxc/lxc-usernet` dan berikan quota `veth`:

``` text
sfx veth lxcbr0 10
```

## Hasil akhir

``` text
Ubuntu 26.04 VM
└── destiny-lxc
    ├── Ubuntu 26.04 (resolute)
    ├── unprivileged: true
    ├── UID 0 container -> UID 100000 host
    ├── network: lxcbr0
    └── berjalan di background
```
