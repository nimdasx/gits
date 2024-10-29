host=0.0.0.0
port=3306
user=root
pass="xxx"

read -p "nama file : " nama_file
read -p "nama db : " nama_db

pv $nama_file | mysql $nama_db -h $host -P $port -u $user -p$pass