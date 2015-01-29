#!/bin/bash

# update apt repositories and install essentials
apt-get -y update
apt-get -y install git curl build-essential python-software-properties
apt-get -qq -y install apg nmap zip unzip tmux vim-nox

## setup postgres/postgis and gis tools

# install postgres 9.3 and postgis 2.1
echo "deb http://apt.postgresql.org/pub/repos/apt trusty-pgdg main" >> /etc/apt/sources.list
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
apt-get -y update
apt-get -y install postgresql-9.3-postgis-2.1 postgresql-contrib

# http://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS21UbuntuPGSQL93Apt
# http://www.peterstratton.com/2014/04/how-to-install-postgis-2-dot-1-and-postgresql-9-dot-3-on-ubuntu-servers/

# install gdal and other gis tools
apt-get -y install binutils libproj-dev gdal-bin libgeoip1 libgtk2.0

# configure postgres with geocodr user and database
su - postgres -c "psql -c \"CREATE USER geocodr WITH PASSWORD 'geocodr' SUPERUSER LOGIN;\""
su - postgres -c "psql -c \"CREATE DATABASE geocodr WITH OWNER geocodr;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION fuzzystrmatch;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION postgis;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION postgis_topology;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION postgis_tiger_geocoder;\""

## setup TIGER database

# create output location
mkdir /gisdata

# configure for loader script generation
su - postgres -c "psql -d geocodr < /install/insert_geocodr_os.sql"
su - postgres -c "psql -d geocodr < /install/update_declare_sect.sql"

# generate and run loader scripts (change IL to target state below)
su - postgres -c "psql -A -t -d geocodr -c \"SELECT loader_generate_nation_script('geocodr');\"" | sh
su - postgres -c "psql -A -t -d geocodr -c \"SELECT loader_generate_script(ARRAY['IL'], 'geocodr');\"" | sh

# install any missing indexes
su - postgres -c "psql -A -t -d geocodr -c \"SELECT install_missing_indexes();\""

# http://gis.stackexchange.com/questions/81907/install-postgis-and-tiger-data-in-ubuntu-12-04
# http://www.peterstratton.com/2014/04/your-own-private-geocoder-using-postgis-and-ubuntu/

## setup geocoder api and service

# install nginx and php
apt-get -y install php5-fpm php5-cli php5-mcrypt php5-pgsql nginx
php5enmod mcrypt
cp /install/nginx.conf /etc/nginx/nginx.conf
rm -rf /etc/nginx/sites-available
rm -rf /etc/nginx/sites-enabled

# install geocodr api app
mkdir /opt/geocodr
mkdir /opt/geocodr/public
cp /install/composer.json /opt/geocodr/composer.json
cp /install/geocodr.php /opt/geocodr/public/index.php
cp /install/config.php /opt/geocodr/config.php
cd /opt/geocodr
curl -s https://getcomposer.org/installer | php
php composer.phar install
chown -R www-data:www-data /opt/geocodr/
service nginx restart

