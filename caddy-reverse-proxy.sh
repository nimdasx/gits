#caddy berfungsi reverse proxy  https/ssl

#install caddy di ubuntu
#source : https://caddyserver.com/docs/install#debian-ubuntu-raspbian
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

#buat IN A stream.radiounisia.com ke ip 202.162.36.222

#buka config caddy di /etc/caddy/Caddyfile :

stream.radiounisia.com {
  reverse_proxy 202.162.36.222:8000
}

#buang/comment semua string setting yang lain, hanya tinggalkan line diatas doang

#enable dan jalankan service caddy
sudo systemctl enable caddy
sudo systemctl restart caddy

#check firewall pastikan tidak memblokir port 80 dan 443