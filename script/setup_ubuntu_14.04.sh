#!/usr/bin/env bash

# setup the enviroment for ubuntu 14.04
USER=`whoami`
PG_PASSWORD='my_passwd'

sudo apt-get update

# Install system packages
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server memcached git-core nodejs imagemagick postfix gcc make

# Install rbenv
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
source ~/.bash_profile

# Install ruby
rbenv install 2.1.2
rbenv global 2.1.2

# Install PostgreSQL
sudo apt-get install -y postgresql libpq-dev
# -d, --createdb The new user will be allowed to create databases.
# -R, --no-createrole The new user will not be allowed to create new roles. This is the default.
# -S, --no-superuser The new user will not be a superuser. This is the default.
sudo su postgres -c "createuser -d -R -S $USER"

# TODO: change /etc/postgresql/9.3/main/pg_hba.conf
# host    all             all             127.0.0.1/32            md5
# to
# host    all             all             127.0.0.1/32            trust

# Install nginx
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install nginx
# https://ruby-china.org/topics/19437
# /opt/nginx/sbin/nginx -V
# nginx version: nginx/1.6.0
# built by gcc 4.8.2 (Ubuntu 4.8.2-19ubuntu1)
# TLS SNI support enabled
# configure arguments: --prefix=/opt/nginx --with-http_ssl_module --with-http_gzip_static_module --with-http_stub_status_module --with-cc-opt=-Wno-error --with-pcre=/tmp/passenger.kbq1wq/pcre-8.34 --add-module=/usr/share/passenger/ngx_http_passenger_module

# Install Passenger
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo bash -c "echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger precise main' > /etc/apt/sources.list.d/passenger.list"
sudo apt-get update
sudo apt-get install -y build-essential libcurl4-openssl-dev ruby-dev
sudo apt-get install -y nginx-extras passenger
