prefix=aaa
host=0.0.0.0
port=3306
user=root
pass="xxx"
databases=bbb
lokasi="/home/yyy/zzz/"

for database in $databases
do
  echo $database
  mysqldump -h $host -P $port -u $user -p$pass -R $database | pv -W -s 100m | gzip > $lokasi$prefix-$database-$(date +"%Y-%m-%d_%H-%M-%S").sql.gz
done