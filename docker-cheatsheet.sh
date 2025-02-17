#format ps
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"

#== images ==
#lihat
docker images
#pull
docker pull mongo:4.1
#hapus
docker image rm mongo:4:1

#== build ==
#build
docker build --tag app-golang:1.0 .

#== push image to registry ==
#create repo via web
#tag
docker tag app-golang:1.0 nimdasx/app-golang:1.0
#push
docker push nimdasx/app-golang:1.0

#== container ==
#yang running
docker container ls
#semua
docker container ls --all
#create
docker container create --name mongoserver1 mongo:4.1
docker container create --name mongoserver2 mongo:4.1
#run
docker container start mongoserver1 mongoserver2
#stop
docker container stop mongoserver1 mongoserver2
#hapus
docker container rm mongoserver1 mongoserver2
#create with expose port keluar
docker container create --name mongoserver1 -p 8080:27017 mongo:4.1
docker container create --name mongoserver2 -p 8181:27017 mongo:4.1

#create external network
docker network create --subnet 192.168.51.0/24 sengguhnet

#== catetan ==
docker create -v fatih:/ibuk-bangun --name ubuntu-data ubuntu /bin/bash
docker image prune -a --filter "label=maintainer=nimdasx@gmail.com"
docker run -d -p 80:80 --name sf-phalcon4 nimdasx/sf-phalcon4
docker exec -it sf-phalcon4 tail -f /var/log/apache2/access.log
docker exec -it sf-phalcon4 /bin/bash
docker rm -f sf-phalcon4
docker build --tag nimdasx/sf-phalcon4 .