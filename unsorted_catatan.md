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
```