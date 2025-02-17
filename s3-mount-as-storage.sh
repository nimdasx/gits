#https://blogs.oracle.com/cloud-infrastructure/post/mounting-an-object-storage-bucket-as-file-system-on-oracle-linux
#s3fs [bucket] [destination directory] \
#-o endpoint=[region] \
#-o passwd_file=${HOME}/.passwd-s3fs \
#-o url=https://[namespace].compat.objectstorage.[region].oraclecloud.com \
#-o nomultipart \
#-o use_path_request_style

s3fs ocibucketnimdasx01 ocibucketnimdasx01 \
-o endpoint=ap-singapore-1 \
-o passwd_file=${HOME}/.passwd-s3fs-ocibucketnimdasx01 \
-o url=https://censored.compat.objectstorage.ap-singapore-1.oraclecloud.com \
-o nomultipart \
-o use_path_request_style


#simpan auth key di .passwd-s3fs-nimdasxspace01
s3fs nimdasxspace01 nimdasxspace01 \
-o passwd_file=${HOME}/.passwd-s3fs-nimdasxspace01 \
-o url=https://sgp1.digitaloceanspaces.com/ \
-o use_path_request_style