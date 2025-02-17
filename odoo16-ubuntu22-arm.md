# run odoo 16 from source on ubuntu 22.04 arm

install wkhtmltopdf, jangan pakai yang bawaannya ubuntu
```sh
sudo apt install xfonts-75dpi
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_arm64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-2.jammy_arm64.deb
```

clone
```bash
git clone git@github.com:odoo/odoo.git
git checkout 16.0

git clone git@github.com:odoo/enterprise.git
git checkout 16.0
```

create virtualenv, masuk, dan install requirement
```bash
sudo apt install libpq-dev gcc python3-dev libldap2-dev libsasl2-dev python3.10-venv g++ postgresql-client
python3 -m venv venvx
source venvx/bin/activate
pip install wheel #atau pip install --upgrade setuptools wheel ?
pip install -r odoo/requirements.txt #stuck di gevent
pip install gevent #install gevent beda versi
pip install pdfminer #gak reti kok butuh iki pas mbukak web muncul warning
deactivate
```

buat config odoo.conf
```ini
[options]
addons_path = /home/ubuntu/odoo16/odoo/addons,/home/ubuntu/odoo16/custom,/home/ubuntu/odoo16/enterprise
xmlrpc_port = 8016
logfile = /home/ubuntu/odoo16/odoo16xyz.log
db_password = xxxxxx
db_user = odoo16
db_host = localhost
data_dir = /home/ubuntu/odoo16/data
```

run odoo
```bash
source venvx/bin/activate
odoo/odoo-bin -c odoo.conf
```

jadikan service
buat file odoo16.service
```ini
[Unit]
Description=Odoo 16
After=docker.service

[Service]
ExecStart=/home/ubuntu/odoo16/venvx/bin/python3 /home/ubuntu/odoo16/odoo/odoo-bin -c /home/ubuntu/odoo16/odoo16.conf
User=ubuntu
Group=ubuntu
StandardOutput=append:/var/log/odoo16.log
StandardError=append:/var/log/odoo16_error.log

[Install]
WantedBy=default.target
```

```bash
cd /etc/systemd/system/
sudo ln -s /home/ubuntu/odoo16/odoo16.service .
sudo systemctl enable odoo16
sudo systemctl start odoo16
```
