prefix=aaa
host=zzz
user=sss
pass=xxx
databases="qqq www"

for database in $databases
do
  mysqldump -h $host -u $user -p$pass -R $database | pv -W -s 100m | gzip > $prefix-$database-$(date +"%Y-%m-%d_%H-%M-%S").sql.gz
done