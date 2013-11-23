#!/usr/bin/env /bin/bash

apt-get update

##########
# Install random tools
##########
apt-get -y install vim python-software-properties curl acl git

##########
# Install user repo for PHP 5.5.* and Apache 2.4.*
##########
add-apt-repository ppa:ondrej/php5
apt-get update

##########
# Install and configure Apache
##########
apt-get -y install apache2

# Create basic web directory
rm -rf /var/www/*
mkdir /var/www/web

# Set the correct Symfony document root
cat /etc/apache2/sites-available/000-default.conf \
  | sed 's/DocumentRoot \/var\/www/DocumentRoot \/var\/www\/web/' \
  > /etc/apache2/sites-available/000-default.new
mv /etc/apache2/sites-available/000-default.new /etc/apache2/sites-available/000-default.conf

# Make sure AllowOverride is set to All
cat /etc/apache2/apache2.conf | sed 's/AllowOverride None/AllowOverride All/' > /etc/apache2/apache2.new
mv /etc/apache2/apache2.new /etc/apache2/apache2.conf

##########
# Install and configure PHP
##########
apt-get -y install php5 php5-gd php5-intl php5-curl

# Set the proper date.timezone configuration options
cat /etc/php5/apache2/php.ini \
  | sed 's/;date.timezone =/date.timezone = America\/Indiana\/Indianapolis/' \
  | sed 's/^memory_limit = 128M/memory_limit = 2048M/' \
  > /etc/php5/apache2/php.new
mv /etc/php5/apache2/php.new /etc/php5/apache2/php.ini
cat /etc/php5/cli/php.ini \
  | sed 's/;date.timezone =/date.timezone = America\/Indiana\/Indianapolis/' \
  | sed 's/^memory_limit = 128M/memory_limit = 2048M/' \
  > /etc/php5/cli/php.new
mv /etc/php5/cli/php.new /etc/php5/cli/php.ini

##########
# Install and configure XDebug
##########
apt-get -y install php5-xdebug
echo "`cat <<EOF
xdebug.remote_enable=on
xdebug.remote_host=10.0.2.2
xdebug.max_nesting_level=256
EOF`" >> /etc/php5/mods-available/xdebug.ini

##########
# Install and configure MySQL
##########
DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server mysql-client php5-mysql
cat /etc/mysql/my.cnf \
  | sed 's/#max_connections.*/max_connections = 1000/' \
  > /etc/mysql/my.cnf.new
mv /etc/mysql/my.cnf.new /etc/mysql/my.cnf

##########
# Install and configure Memcached
##########
apt-get -y install memcached php5-memcached
cat /etc/memcached.conf | sed 's/-m 64/-m 128/' > /etc/memcached.new
mv /etc/memcached.new /etc/memcached.conf

##########
# Install and configure Postfix
##########
DEBIAN_FRONTEND=noninteractive apt-get -y install postfix mailutils
echo "`cat <<EOF
smtpd_banner = \\$myhostname ESMTP \\$mail_name (Ubuntu)
biff = no

append_dot_mydomain = no
readme_directory = no

myhostname = precise64
mydestination = precise64, localhost.localdomain, localhost
mynetworks = 127.0.0.0/8
inet_interfaces = loopback-only
EOF`" > /etc/postfix/main.cf

##########
# Install composer
##########
php -r "eval('?>'.file_get_contents('https://getcomposer.org/installer'));" -- --install-dir=/usr/local/bin
mv /usr/local/bin/composer.phar /usr/local/bin/composer

##########
# Install current version of application to web root
##########
cp -R /vagrant/* /var/www
chown -R vagrant:vagrant /var/www
mkdir -p /var/www/app/cache
mkdir -p /var/www/app/logs
setfacl -Rm u:vagrant:rwx /var/www/app/cache /var/www/app/logs
setfacl -dRm u:vagrant:rwx /var/www/app/cache /var/www/app/logs
setfacl -Rm u:www-data:rwx /var/www/app/cache /var/www/app/logs
setfacl -dRm u:www-data:rwx /var/www/app/cache /var/www/app/logs

##########
# Restart all newly installed services
##########
service postfix restart
service apache2 restart
service mysql restart
service memcached restart