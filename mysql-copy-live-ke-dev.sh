mysqldump -R atgov_sumsel > atgov_sumsel.sql
mysql -e 'drop database if exists dev_atgov_sumsel'
mysql -e 'create database dev_atgov_sumsel character set utf8 collate utf8_general_ci'
mysql dev_atgov_sumsel < atgov_sumsel.sql
rm atgov_sumsel.sql
echo "selesai kloning dari live ke dev"
