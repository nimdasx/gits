```
vi /etc/systemd/system/ScreenOff.service

[Unit]
Description=Turn off screen after 1 minute
[Service]
Type=oneshot
ExecStart=/usr/bin/setterm -term linux -blank 1 -powersave powerdown -powerdown 1 </dev/tty1 >/dev/tty1
[Install]
WantedBy=multi-user.target

systemctl enable ScreenOff.service
systemctl start ScreenOff.service
```

thanks source https://forum.proxmox.com/threads/systemmd-boot-screen-off-after-one-minute.123125/