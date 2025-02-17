```
mkdir ~/odoo16community 

cd ~/odoo16community  
mkdir postgres16  
cd postgres16  
vim docker-compose.yml  
```
```
services:
  db:
    container_name: odoo16community_postgres16
    image: postgres:16-alpine
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
cd ~/odoo16community/postgres16
docker compose up -d
```
```
cd ~  
sudo apt install xfonts-75dpi fontconfig libjpeg-turbo8 libxrender1 xfonts-base
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb  
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb  
rm wkhtmltox_0.12.6.1-3.jammy_amd64.deb  

cd ~/odoo16community  
git clone git@github.com:odoo/odoo.git  
cd odoo  
git checkout 16.0  

cd ~  
sudo apt install libpq-dev gcc python3-dev libldap2-dev libsasl2-dev python3.10-venv g++ postgresql-client  
cd ~/odoo16community  
python3 -m venv venvx  
source venvx/bin/activate  
pip install wheel #atau pip install --upgrade setuptools wheel ?  
pip install -r odoo/requirements.txt #stuck di gevent  
pip install gevent #install gevent beda versi  
pip install pdfminer #gak reti kok butuh iki pas mbukak web muncul warning  
deactivate  

cd ~/odoo16community  
vim odoo16community.conf  
```
```
[options]
addons_path = /home/dev/odoo16community/odoo/addons
xmlrpc_port = 8016
db_password = vstyfhfhjd
db_user = odongodong
db_host = localhost
data_dir = /home/dev/odoo16community/odoodata
```
```
cd ~/odoo16community  
vim odoo16community.service  
```
```
[Unit]
Description=Odoo 16 Community
After=docker.service

[Service]
ExecStart=/home/dev/odoo16community/venvx/bin/python3 /home/dev/odoo16community/odoo/odoo-bin -c /home/dev/odoo16community/odoo16community.conf
User=dev
Group=dev
StandardOutput=append:/home/dev/odoo16community/stdout.log
StandardError=append:/home/dev/odoo16community/stderr.log

[Install]
WantedBy=default.target
```
```
cd ~/odoo16community  
sudo ln -s ~/odoo16community/odoo16community.service /etc/systemd/system  
sudo systemctl enable odoo16community  
sudo systemctl start odoo16community  
```