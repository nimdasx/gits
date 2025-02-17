# run odoo 16 from source on mac

## step

requirement :    
install server postogresql 14 atau run di docker, buat superuser odoo16 dengan password heartache

install kebutuhan di brew
```
brew install postgresql wkhtmltopdf
```

buat direktori odoo16src  

clone source code community dari direktori odoo16src :  
```
git clone git@github.com:odoo/odoo.git 
git checkout 16:0
```
clone source code enterprise dari direktori odoo16src :  
```
git clone git@github.com:odoo/enterprise.git
git checkout 16:0
```

create virtualenv dari direktori odoo16src , masuk ke virtualenv, dan install requirement :
```
python3 -m venv mayat
source mayat/bin/activate
python3 -m pip install --upgrade pip
pip install -r odoo/requirements.txt
```

buat config odoo.conf :
```
[options]
addons_path = /Users/xxx/odoo16src/odoo/addons,/Users/xxx/odoo16src/custom,/Users/xxx/odoo16src/enterprise
db_password = heartache
db_user = odoo16
db_host = localhost
data_dir = /Users/xxx/odoo16src/data
```

run odoo :
```
source mayat/bin/activate
python3 odoo/odoo-bin -c odoo.conf
```

run odoo tanpa masuk virtual env :
```
/Users/xxx/odoo16src/mayat/bin/python /Users/xxx/odoo16src/odoo/odoo-bin -c /Users/xxx/odoo16src/odoo.conf
```

browse http://localhost:8069/ dan jangan lupa set master password  

## note  

pastikan struktur folder dan file-nya jadi seperti ini :  
```
odoo16src/custom
odoo16src/data
odoo16src/enterprise
odoo16src/odoo
odoo16src/odoo.conf
odoo16src/mayat
```

jika muncul error :  
```
brew install openssl  
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/Cellar/openssl@3/3.1.1/lib  
```