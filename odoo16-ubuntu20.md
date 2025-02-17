# Run Odoo 16 from Source on Ubuntu 20

install wkhtmltopdf, jangan pakai yang bawaannya ubuntu
```sh
sudo apt install xfonts-75dpi
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6-1.focal_amd64.deb
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
sudo apt install libpq-dev gcc python3-dev libldap2-dev libsasl2-dev python3-venv g++ postgresql-client
python3 -m venv venvodoo16
source venvodoo16/bin/activate
pip install wheel
pip install -r odoo/requirements.txt
pip install pdfminer #gak reti kok butuh iki pas mbukak web muncul warning
deactivate
```

buat config odoo16.conf
```ini
[options]
addons_path = /home/softdev/odoo16/odoo/addons,/home/softdev/odoo16/custom,/home/softdev/odoo16/enterprise
xmlrpc_port = 8016
logfile = /home/softdev/odoo16/odoo16.log
db_password = xxxxxx
db_user = odoo16
db_host = localhost
data_dir = /home/softdev/odoo16/data
proxy_mode = True
```

run odoo
```bash
source venvodoo16/bin/activate
odoo/odoo-bin -c odoo16.conf
```

jadikan service
buat file odoo16.service
```ini
[Unit]
Description=Odoo 16
After=docker.service

[Service]
ExecStart=/home/softdev/odoo16/venvodoo16/bin/python3 /home/softdev/odoo16/odoo/odoo-bin -c /home/softdev/odoo16/odoo16.conf
User=softdev
Group=softdev
StandardOutput=append:/home/softdev/odoo16/stdout.log
StandardError=append:/home/softdev/odoo16/stderr.log

[Install]
WantedBy=default.target
```

```bash
cd /etc/systemd/system/
sudo ln -s /home/softdev/odoo16/odoo16.service .
sudo systemctl enable odoo16
sudo systemctl start odoo16
```
