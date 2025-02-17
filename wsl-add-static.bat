rem https://github.com/microsoft/WSL/issues/4210#issuecomment-648570493
wsl -d ubuntu-01 -u root ip addr add 192.168.50.2/24 broadcast 192.168.50.255 dev eth0 label eth0:1
netsh interface ip add address "vEthernet (WSL)" 192.168.50.1 255.255.255.0