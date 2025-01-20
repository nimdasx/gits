# cockpit

```
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit

#source https://cockpit-project.org/faq.html#error-message-about-being-offline
nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
```

```
nmcli connection
nmcli connection delete fake
```