# docker

## install docker on nux
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
```

## backup
```
#backup /etc/letsencrypt dari container nginxpm-nginxmp-1 ke file backup/nginxmp-letsencrypt.tar
docker run --rm --volumes-from nginxpm-nginxpm-1 -v $(pwd):/backup ubuntu tar cvf /backup/nginxpm-letsencrypt.tar /etc/letsencrypt
```

## npm run
```
docker run -p 4173:4173 -it --rm -v "$PWD":/app -w /app node:lts-alpine npm run preview -- --host
```

## tambahkan ini di tiap service docker compose ben ora kebak
```
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
```