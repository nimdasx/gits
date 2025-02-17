#install phalcon 5 di cloudpanel php 8.1

sudo apt update
sudo apt install php8.1-dev

curl -O https://pecl.php.net/get/phalcon-5.0.2.tgz
tar xf phalcon-5.0.2.tgz
cd phalcon-5.0.2/
phpize8.1

./configure
make
sudo make install

sudo vim /etc/php/8.1/cli/php.ini
extension=phalcon.so

sudo vim /etc/php/8.1/fpm/php.ini
extension=phalcon.so

sudo systemctl restart php8.1-fpm.service