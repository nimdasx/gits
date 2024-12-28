# unsorted cacatan

## cek usb camera on linux
```
#add user dev to group video
sudo usermod -a -G video dev
#cek webcam
sudo apt install v4l-utils
v4l2-ctl --list-devices
#test webcam
sudo apt-get install fswebcam
fswebcam --device /dev/video0 video0.jpg
```

## reset password odoo ke 1
```
$pbkdf2-sha512$25000$4xwjZEwJgbCWsvaec875nw$eKhXFLBpAWHixi3QaE4/UHVfDLKEFLV5ZG4HFWP2FfctTAi6Jx4pahTQWgnVbqO3yXl9AQgdM8gHksNrbrh8Jg
update res_users set password='$pbkdf2-sha512$25000$4xwjZEwJgbCWsvaec875nw$eKhXFLBpAWHixi3QaE4/UHVfDLKEFLV5ZG4HFWP2FfctTAi6Jx4pahTQWgnVbqO3yXl9AQgdM8gHksNrbrh8Jg';
```

## nyalakan lampu philips wiz
```
/Users/xxx/Library/Python/3.8/bin/wizcon 192.168.xxx.xxx on
```

## buat update.sh
```
echo -e '#!/bin/bash\ntmux new-session -d -s aptupdatemendem "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && exit"' > update.sh && chmod +x update.sh
```

## reinstall
```
sudo apt purge somepackage
sudo apt install somepackage
```
