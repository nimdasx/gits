# lxc
warning, harus console karena koneksi bisa putus

## what todo
```
sudo apt install lxc
```

/etc/netplan/00-installer-config.yaml
```
network:
  ethernets:
    enp3s0:
      dhcp4: no
  bridges:
    brzgmf:
      interfaces:
        - enp3s0
      addresses:
        - 192.168.1.2/24
      routes:
        - to: 0.0.0.0/0
          via: 192.168.1.1
      nameservers:
        addresses:
        - 192.168.1.1
      #search: []
  version: 2
```

```
sudo netplan apply
```

/etc/lxc/default.conf
```
#lxc.net.0.link = lxcbr0
lxc.net.0.link = brzgmf
```

```
#buat lxc container
sudo lxc-create --name ctd --template download -- --dist ubuntu --release noble --arch amd64
```

/var/lib/lxc/ctd/config
```
lxc.net.0.link = brzgmf
lxc.net.0.ipv4.address = 192.168.1.3/24
lxc.net.0.ipv4.gateway = 192.168.1.1
lxc.start.auto = 1
```

```
sudo lxc-attach ctd
```

/etc/systemd/resolved.conf
```
DNS=192.168.1.1
```