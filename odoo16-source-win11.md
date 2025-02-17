# Run Odoo 16 from Source on Windows 11

## python 3.11   
https://www.python.org/ftp/python/3.11.4/python-3.11.4-amd64.exe  
install for all user dan add path

## wkhtmltopdf 0.12.6-1     
https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox-0.12.6-1.mxe-cross-win64.7z  
extract ke C:\prog\  
masukkan C:\prog\wkhtmltox\bin ke path  

## visual studio build tools   
https://visualstudio.microsoft.com/visual-cpp-build-tools/  
dari visual studio installer, install Visual Studio Build Tools 2022, centang Desktop development with C++  
install dan tunggu bergiga2   

## posgresql 14 pakai docker   
buat folder C:\prog\postgresql14  
buat file docker-compose.yml di dalam C:\prog\postgresql14 isinya  :  
```
services:
  db:
    image: postgres:14-alpine
    restart: unless-stopped
    ports:
      - 5432:5432
    volumes:
      - ./varlibpostgresqldata:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=sr3rgdg6j
      - POSTGRES_DB=postgres
``` 
jalankan postgresql 14 dengan perintah     
```
cd C:\prog\postgresql14  
docker compose up -d  
```

## pgadmin 4    
https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v7.3/windows/pgadmin4-7.3-x64.exe  
dari pgadmin 4 buat koneksi "add new server" ke postgresql 14 dengan parameter  
```
Host name/address : localhost
user : postgres
password : sr3rgdg6j
```
dari pgadmin 4 pilih server yang tadi dibuat,  
buat superuser (klik kanan Login/Group Roles, Create Login/Group Role) dengan parameter
```
Name : odoo16
Password : heartache
```
dari tab Privileges, centang "Can login?" dan "Superuser?"  

## buat folder  
```
mkdir C:\devodoo16
```

## source code odoo 16  
```
cd C:\devodoo16
git clone --depth 1 --branch 16.0 git@github.com:odoo/odoo.git
cd odoo 
git checkout 16:0  
```

## source code addons enterprise odoo 16  
```
cd C:\devodoo16
git clone --depth 1 --branch 16.0 git@github.com:odoo/enterprise.git
cd enterprise
git checkout 16:0  
```

## create virtualenv vxz  
```
cd C:\devodoo16
python -m venv vxz
```
## masuk ke virtualenv vxz dan install requirement  
```
cd C:\devodoo16
.\vxz\Scripts\activate
pip install -r .\odoo\requirements.txt
```

## buat folder  
```
mkdir C:\devodoo16\custom
mkdir C:\devodoo16\data  
```

## buat config odoo.conf di folder C:\devodoo16 isinya :  
```
[options]
addons_path = .\odoo\addons,.\custom,.\enterprise
db_password = heartache
db_user = odoo16
data_dir = .\data
```

## pastikan susunan file dan folder di dalam C:\devodoo16 seperti ini :  
```
custom
data
enterprise
odoo
vxz
odoo.conf
```

## run odoo dari C:\devodoo16 :  
```
.\vxz\Scripts\activate
python .\odoo\odoo-bin -c .\odoo.conf
```
atau
```
.\vxz\Scripts\python.exe .\odoo\odoo-bin -c .\odoo.conf
```

## browse 
http://localhost:8069  
done   