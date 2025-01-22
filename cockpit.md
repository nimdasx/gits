# cockpit
https://cockpit-project.org/faq

```
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit

sudo vim /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
```
```
[keyfile]
 unmanaged-devices=none
```
```
#source https://cockpit-project.org/faq.html#error-message-about-being-offline
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
```

```
nmcli connection
nmcli connection delete fake
```