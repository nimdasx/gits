#docker tanpa "docker desktop" di windows dan tetep pakai wsl, murni docker engine kayak di server

#aktifkan wsl
#Turn Windows features on or off, check "Windows Subsystem for Linux" atau
wsl --install

#install ubuntu 20.04 di wsl
#buka microsoft store, install ubuntu dari sana, atau
wsl --install -d ubuntu
ubuntu config --default-user root

#install docker
#follow normal installation from https://docs.docker.com/engine/install/ubuntu

#jangan lupa start docker
wsl service docker start