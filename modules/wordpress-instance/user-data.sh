#!/bin/bash
set -ex

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# This script is set up using https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-20-04-with-a-lamp-stack
# as a guide.

sudo apt update

# Install LAMP components, Wordpress, and other necessary packages
sudo apt install -y awscli fail2ban apache2 mysql-server php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

# Clean up MySQL insecure defaults similar to what mysql_secure_installation would do
# Taken from https://lowendbox.com/blog/automating-mysql_secure_installation-in-mariadb-setup/
# and adapted to address a deprecated feature for resetting the password.
sudo mysql -sfu root <<EOT
-- set root password
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_root_password}';
-- delete anonymous users
DELETE FROM mysql.user WHERE User='';
-- delete remote root capabilities
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- drop database 'test'
DROP DATABASE IF EXISTS test;
-- also make sure there are lingering permissions to it
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- make changes immediately
FLUSH PRIVILEGES;
EOT

# Create the database for WordPress
sudo mysql -sfu root -p${mysql_root_password} <<EOT
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpressuser'@'%' IDENTIFIED WITH mysql_native_password BY '${mysql_wordpressuser_password}';
GRANT ALL ON wordpress.* TO 'wordpressuser'@'%';
FLUSH PRIVILEGES;
EOT

# Download WordPress and perform some initial setup
curl -O -s https://wordpress.org/wordpress-5.8.tar.gz
sudo tar xzf wordpress-5.8.tar.gz
sudo touch wordpress/.htaccess
sudo cp wordpress/wp-config-sample.php wordpress/wp-config.php
sudo mkdir /wordpress/wp-content/upgrade
sudo cp -a wordpress/. /var/www/${domain}
sudo chown -R www-data:www-data /var/www/${domain}
sudo find /var/www/${domain}/ -type d -exec chmod 750 {} \;
sudo find /var/www/${domain}/ -type f -exec chmod 640 {} \;
# Next bit taken from https://stackoverflow.com/a/6233537
SALT=$(curl -s -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s /var/www/${domain}/wp-config.php
# Fill in the DB parameters in the config file
sed -i 's/database_name_here/wordpress/' /var/www/${domain}/wp-config.php
sed -i 's/username_here/wordpressuser/' /var/www/${domain}/wp-config.php
sed -i 's/password_here/${mysql_wordpressuser_password}/' /var/www/${domain}/wp-config.php
echo "define('FS_METHOD', 'direct');" >> /var/www/${domain}/wp-config.php

# Create Apache config for the website
cat <<EOT >> /etc/apache2/sites-available/${domain}.conf
<VirtualHost *:80>
    ServerName ${domain}
    ServerAlias www.${domain}
    DocumentRoot /var/www/${domain}
    ErrorLog $${APACHE_LOG_DIR}/error.log
    CustomLog $${APACHE_LOG_DIR}/access.log combined
    <Directory /var/www/${domain}/>
        AllowOverride All
    </Directory>
</VirtualHost>
EOT

# Enable mod_rewrite for prettier URIs
sudo a2enmod rewrite

sudo a2ensite ${domain}
sudo a2dissite 000-default

# Set up Let's Encrypt

sudo snap install core; sudo snap refresh core
sudo apt -y remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --apache --non-interactive --agree-tos -m vytautas.kubilius@gmail.com --domains ${domain},www.${domain}

# Create backup and restore scripts

sudo mkdir /opt/scripts
sudo chown ubuntu:ubuntu /opt/scripts

sudo cat <<EOT >> /opt/scripts/backup.sh
mysqldump -u root -p${mysql_root_password} -A -B > dump.sql
tar Pczf backup.tar.gz /var/www/${domain} dump.sql
aws s3 cp backup.tar.gz s3://${domain}-backup/backup.tar.gz
EOT

sudo cat <<EOT >> /opt/scripts/restore.sh
aws s3 cp s3://${domain}-backup/backup.tar.gz backup.tar.gz
tar Pxzf backup.tar.gz
mysql -u root -p${mysql_root_password} < dump.sql
EOT

# Create a cron job to perform daily backups

sudo crontab<<EOT
0 3 * * * bash /opt/scripts/backup.sh
EOT

sudo systemctl reload apache2
