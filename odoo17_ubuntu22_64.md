# catatan
- petunjuk ini untuk instalasi di server/vps menggunakan os ubuntu versi 22 arsitektur x86/64
- database postgresql menggunakan docker, install dahulu docker engine melalui link berikut https://docs.docker.com/engine/install/ubuntu/
- versi odoo yang digunakan adakan 17.0

## setup progresql di docker

```
mkdir ~/odoo17 
cd ~/odoo17
mkdir postgres14  
cd postgres14  
vim docker-compose.yml  
```
```
services:
  db:
    container_name: odoo17_postgres14
    image: postgres:14-alpine
    restart: unless-stopped
    ports:
      - 5432:5432
    volumes:
      - ./varlibpostgresqldata:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=kD3r89FFDK
      - POSTGRES_DB=postgres
```
```
cd ~/odoo17/postgres14
docker compose up -d
```
### buat user database odoo
gunakan pgadmin atau tool postgres lainnya untuk membuat superuser database sbb :  
user database : odongodong  
password database : vstyfhfhjd  

## setup odoo
```
cd ~  
sudo apt install xfonts-75dpi fontconfig libjpeg-turbo8 libxrender1 xfonts-base
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb  
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb  
rm wkhtmltox_0.12.6.1-3.jammy_amd64.deb  

cd ~/odoo17  
git clone --depth 1 --branch 17.0 git@github.com:odoo/odoo.git  
cd odoo  
git checkout 17.0  

cd ~  
sudo apt install libpq-dev gcc python3-pip python3-dev libldap2-dev libsasl2-dev python3.10-venv g++ postgresql-client  
cd ~/odoo17  
python3 -m venv venvx  
source venvx/bin/activate  
pip install -r odoo/requirements.txt  
#gak reti kok butuh iki pas mbukak web muncul warning
pip install pdfminer   
#untuk integrasi dengan whatsapp
pip install phonenumbers
#untuk app social marketing
pip install google_auth
deactivate  

cd ~/odoo17  
vim odoo17.conf  
```
catatan : sesuaikan /home/dev dengan home direktori anda
```
[options]
addons_path = /home/dev/odoo17/odoo/addons
xmlrpc_port = 8016
db_password = vstyfhfhjd
db_user = odongodong
db_host = localhost
data_dir = /home/dev/odoo17/data
proxy_mode = True
limit_time_real = 100000
```
```
cd ~/odoo17  
vim odoo17.service  
```
catatan : sesuaikan /home/dev dengan home direktori anda
```
[Unit]
Description=Odoo 17
After=docker.service

[Service]
ExecStart=/home/dev/odoo17/venvx/bin/python3 /home/dev/odoo17/odoo/odoo-bin -c /home/dev/odoo17/odoo17.conf
User=dev
Group=dev
StandardOutput=append:/home/dev/odoo17/stdout.log
StandardError=append:/home/dev/odoo17/stderr.log

[Install]
WantedBy=default.target
```
```
cd ~/odoo17  
sudo ln -s ~/odoo17/odoo17.service /etc/systemd/system  
sudo systemctl enable odoo17  
sudo systemctl start odoo17  
```