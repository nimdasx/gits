# LXC Bridged Network

Setup:

```text
VM       : destiny
Host user: sfx
LXC      : destiny-lxc
Type     : Unprivileged
LAN      : 192.168.100.0/24
Bridge   : br0
```

## 1. Host Netplan

Edit:

```bash
sudo nano /etc/netplan/50-cloud-init.yaml
```

```yaml
network:
  version: 2
  ethernets:
    ens18:
      match:
        macaddress: xx:xx:xx:xx:xx:xx
      set-name: ens18
  bridges:
    br0:
      interfaces:
        - ens18
      dhcp4: true
      dhcp6: true
```

Apply:

```bash
sudo netplan apply
```

> Sebaiknya lewat Proxmox Console karena network bisa terputus.

## 2. Izinkan `sfx` menggunakan `br0`

Edit:

```bash
sudo nano /etc/lxc/lxc-usernet
```

Tambahkan:

```text
sfx veth br0 10
```

## 3. Ubah Network LXC

Edit:

```bash
nano ~/.local/share/lxc/destiny-lxc/config
```

```ini
lxc.net.0.type = veth
lxc.net.0.link = br0
lxc.net.0.flags = up
```

Tetap **unprivileged**, jangan ubah:

```ini
lxc.idmap = u 0 100000 65536
lxc.idmap = g 0 100000 65536
```

## 4. Start & Cek

```bash
lxc-start -n destiny-lxc
lxc-info -n destiny-lxc
```

Target IP:

```text
destiny     → 192.168.100.10
destiny-lxc → 192.168.100.x
```

Keduanya sekarang berada langsung di LAN yang sama, tanpa `10.0.3.0/24`/NAT.
