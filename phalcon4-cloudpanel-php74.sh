#update dan install php dev dulu

sudo apt update
sudo apt install php7.4-dev

#install dulu psr

curl -O https://pecl.php.net/get/psr-1.2.0.tgz
tar zxvf psr-1.2.0.tgz
cd psr-1.2.0
phpize7.4
./configure
make
sudo make install

sudo vim /etc/php/7.4/cli/php.ini
extension=psr.so

sudo vim /etc/php/7.4/fpm/php.ini
extension=psr.so

#baru install phalcon

curl -O https://pecl.php.net/get/phalcon-4.1.2.tgz
tar xf phalcon-4.1.2.tgz
cd phalcon-4.1.2
phpize7.4
./configure
#make suwe banget iki nunggune
make
sudo make install

sudo vim /etc/php/7.4/cli/php.ini
extension=phalcon.so

sudo vim /etc/php/7.4/fpm/php.ini
extension=phalcon.so

#restart service

sudo systemctl restart php7.4-fpm.service
