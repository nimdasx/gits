#podman di wsl

#aktifkan wsl jika belum
#buka menu Turn Windows features on or off, check "Windows Subsystem for Linux" atau pakai perintah :
wsl --install

#install ubuntu 22.04 di wsl
#buka microsoft store, cari ubuntu 22.04 lalu install, 
#atau kalau kamu pakai windows 10 ltsc karna gak ada microsoft store, bisa pakai powershell ini :
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx -UseBasicParsing
Add-AppxPackage .\Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile ubuntu-2204.appx -UseBasicParsing
Add-AppxPackage .\ubuntu-2204.appx
#kemudian click icon Ubuntu 22.04 LTS dari start menu, ikuti langkah2nya, selesai
 
#jadikan default user ubuntu 22.04 jadi root ben gak perlu sitik2 sudo
ubuntu2204.exe config --default-user root

#install podman
wsl apt update
wsl apt upgrade
wsl apt install podman

#install podman-compose
wsl apt install python3-dotenv
wsl curl -o /usr/local/bin/podman-compose https://raw.githubusercontent.com/containers/podman-compose/devel/podman_compose.py
wsl chmod +x /usr/local/bin/podman-compose

#podman ini daemon-less, jadi gak perlu menjalankan service podman, langsung aja jalan-kan container dockermu, caranya
#ganti perindah "docker" dengan "podman", contoh
#"docker run" menjadi "wsl docker run"
#"docker-compose up -d" menjadi "wsl podman-compose up -d"