#!/bin/bash
mkdir /tmp/ssm
curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm -o /tmp/ssm/amazon-ssm-agent.rpm
sudo yum install -y /tmp/ssm/amazon-ssm-agent.rpm
sudo stop amazon-ssm-agent
sudo -E amazon-ssm-agent -register -code "activation-code" -id "activation-id" -region "us-east-2"
sudo start amazon-ssm-agent
sudo yum -y install nginx

systemctl start nginx
systemctl enable nginx

#php php-fpm

sudo yum -y install php-mysqli
sudo yum -y install php php-fpm

systemctl start php-fpm

# mysql

sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install -y mysql80-community-release-el9-1.noarch.rpm
sudo dnf install -y mysql-shell
sudo yum install -y mysql-server
sudo service mysqld start

# efs

sudo yum install -y amazon-efs-utils nfs-utils
sudo wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo python3 /tmp/get-pip.py
sudo pip3 install botocore
sudo yum install -y gcc openssl-devel

# efs mount
sudo mkdir /efs
cd /efs
sudo chmod go+rw .
sudo mount -t efs -o tls ${efs_id}:/ .


# wordpress

# wget https://wordpress.org/latest.tar.gz
# tar -xzf latest.tar.gz
# latest.tar.gz  wordpress
# cd wordpress

cd /home/ec2-user
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cd wordpress
sudo cp -r * /efs/

# nginx conf

cat <<EOF > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;

        server_name  _;

        root            /efs;

        include /etc/nginx/default.d/*.conf;
    }
}

EOF

cd /efs

cat << EOF > wp-config.php

<?php
define( 'DB_NAME', '${db_name_rds}' );
define( 'DB_USER', 'admin' );
define( 'DB_PASSWORD', '${random_pswd}' );
define( 'DB_HOST', '${endpoint_rds}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define('AUTH_KEY',         '${random_string_array[0]}');
define('SECURE_AUTH_KEY',  '${random_string_array[1]}');
define('LOGGED_IN_KEY',    '${random_string_array[2]}');
define('NONCE_KEY',        '${random_string_array[3]}');
define('AUTH_SALT',        '${random_string_array[4]}');
define('SECURE_AUTH_SALT', '${random_string_array[5]}');
define('LOGGED_IN_SALT',   '${random_string_array[6]}');
define('NONCE_SALT',       '${random_string_array[7]}');

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );
define( 'FS_METHOD', 'direct' );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

EOF

sudo systemctl restart nginx
sudo systemctl restart php-fpm
