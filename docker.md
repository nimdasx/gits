# docker

## lokal builder for amd64, remote builder for arm64
https://dev.to/aboozar/build-docker-multi-platform-image-using-buildx-remote-builder-node-5631
```
# local builder for amd64
docker buildx create \
--name gundambuilder \
--node rx78gexnode \
--platform linux/amd64

# remote builder for arm64
docker buildx create \
--name gundambuilder \
--append \
--node kyriosnode \
--platform linux/arm64 \
ssh://xxx@xxx.xxx.xxx.xxx

# use and boot
docker buildx use gundambuilder
docker buildx inspect --bootstrap

# test build and push
docker buildx build --platform linux/amd64,linux/arm64 --tag nimdasx/apache-php7-phalcon4 --push .
```

## install docker on nux
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
```

## ubstakk docker on nux 
```
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker run hello-world

sudo groupadd docker

sudo usermod -aG docker $USER

newgrp docker

docker run hello-world

sudo systemctl enable docker.service
sudo systemctl enable containerd.service
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