host=localhost
user=qqq
pass=xxx
databases="aaa bbb ccc"
lokasi_utama="/home/qqq/www-mysql-backup-per-file/"

for database in $databases
do

  tanggal=$(date +"%Y-%m-%d_%H-%M-%S")
  lokasi_table="$lokasi_utama$database-$tanggal"
  tables=$(mysql -NBA -h $host -u $user -p$pass  -D $database -e 'select TABLE_NAME from information_schema.TABLES where TABLE_SCHEMA = "'$database'" and TABLE_TYPE = "BASE TABLE" ORDER BY TABLE_NAME')
  
  echo "create folder"
  mkdir $lokasi_table

  echo "dumping schema $database"
  mysqldump -h $host -u $user -p$pass -R $database --no-data | pv -W -s 10m | gzip > $lokasi_table/aaa_schema_$database.sql.gz

  echo "dumping data"
  for table in $tables
  do
    echo "$table"
    mysqldump -h $host -u $user -p$pass $database $table  \
      --no-create-info \
      --skip-triggers \
      --no-create-db \
      --compact \
      | pv -W -s 100m | gzip > $lokasi_table/$table.sql.gz
  done

done