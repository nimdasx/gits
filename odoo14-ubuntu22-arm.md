# run odoo 14 from source on ubuntu 22.04 arm

install wkhtmltopdf, jangan pakai yang bawaannya ubuntu
```sh
sudo apt install xfonts-75dpi
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_arm64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-2.jammy_arm64.deb
```

clone
```bash
git clone git@github.com:odoo/odoo.git
git checkout 14.0

git clone git@github.com:odoo/enterprise.git
git checkout 14.0
```

create virtualenv, masuk, dan install requirement
```bash
sudo apt install libpq-dev gcc python3-dev libldap2-dev libsasl2-dev python3.10-venv g++ libjpeg-dev postgresql-client
python3 -m venv venvodoo14
source venvodoo14/bin/activate
pip install wheel #atau pip install --upgrade setuptools wheel ?
pip install -r odoo/requirements.txt #stuck di gevent
pip install gevent #install gevent beda versi
#pip install pdfminer #gak reti kok butuh iki pas mbukak web muncul warning
deactivate
```

buat config odoo14.conf
```ini
[options]
addons_path = /home/ubuntu/odoo14/odoo/addons,/home/ubuntu/odoo14/custom,/home/ubuntu/odoo14/enterprise
xmlrpc_port = 8014
logfile = /home/ubuntu/odoo14/odoo14xyz.log
db_password = xxxxxx
db_user = odoo14
db_host = localhost
data_dir = /home/ubuntu/odoo14/data
```

run odoo
```bash
source venvodoo14/bin/activate
odoo/odoo-bin -c odoo14.conf
```

jadikan service
buat file odoo14.service
```ini
[Unit]
Description=Odoo 14
After=docker.service

[Service]
ExecStart=/home/ubuntu/odoo14/venvodoo14/bin/python3 /home/ubuntu/odoo14/odoo/odoo-bin -c /home/ubuntu/odoo14/odoo14.conf
User=ubuntu
Group=ubuntu
StandardOutput=append:/var/log/odoo14.log
StandardError=append:/var/log/odoo14_error.log

[Install]
WantedBy=default.target
```

```bash
cd /etc/systemd/system/
sudo ln -s /home/ubuntu/odoo14/odoo14.service .
sudo systemctl enable odoo14
sudo systemctl start odoo14
```
