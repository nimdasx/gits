# docker
```
#backup /etc/letsencrypt dari container nginxpm-nginxmp-1 ke file backup/nginxmp-letsencrypt.tar
docker run --rm --volumes-from nginxpm-nginxpm-1 -v $(pwd):/backup ubuntu tar cvf /backup/nginxpm-letsencrypt.tar /etc/letsencrypt
```