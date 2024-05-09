#!/bin/bash
sudo apt update
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

#The next 4 lines is a single command
sudo apt install -y apache2 libapache2-mod-php7.4 mariadb-server openssl redis-server wget php7.4 php7.4-
imagick php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-mbstring php7.4-gmp
php7.4-bcmath php7.4-mysql php7.4-ssh2 php7.4-xml php7.4-zip php7.4-apcu php7.4-redis php7.4-ldap phpphpseclib
sudo a2enmod dir env headers mime rewrite setenvif
sudo systemctl restart apache2
cd /var/www/html
sudo rm *
sudo wget https://download.owncloud.com/server/stable/owncloud-complete-latest.tar.bz2
sudo tar -xjf owncloud-complete-latest.tar.bz2
sudo chown -R www-data. owncloud
sudo systemctl restart apache2

echo "PUBLIC SERVER INSTANCE" > /var/www/html/index.html