#!/bin/bash

# update apt repositories and install essentials
apt-get -y update
apt-get -y install git curl unzip build-essential python-software-properties

# install postgres 9.3 and postgis 2.1
# http://trac.osgeo.org/postgis/wiki/UsersWikiPostGIS21UbuntuPGSQL93Apt
# http://www.peterstratton.com/2014/04/how-to-install-postgis-2-dot-1-and-postgresql-9-dot-3-on-ubuntu-servers/
echo "deb http://apt.postgresql.org/pub/repos/apt trusty-pgdg main" >> /etc/apt/sources.list
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
apt-get -y update
apt-get -y install postgresql-9.3-postgis-2.1 postgresql-contrib

# install gdal and other gis tools
apt-get -y install binutils libproj-dev gdal-bin libgeoip1 libgtk2.0

# configure postgres with geocodr user and database
su - postgres -c "psql -c \"CREATE USER geocodr WITH PASSWORD 'geocodr' SUPERUSER LOGIN;\""
su - postgres -c "psql -c \"CREATE DATABASE geocodr WITH OWNER geocodr;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION fuzzystrmatch;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION postgis;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION postgis_topology;\""
su - postgres -c "psql -d geocodr -c \"CREATE EXTENSION postgis_tiger_geocoder;\""

# setup geocoder loader
# http://gis.stackexchange.com/questions/81907/install-postgis-and-tiger-data-in-ubuntu-12-04
# http://www.peterstratton.com/2014/04/your-own-private-geocoder-using-postgis-and-ubuntu/
# note : the array on line 35 accepts states to use when generating the loading scripts
mkdir /gisdata
# configure for loader script generation
su - postgres -c "psql -d geocodr < /vagrant/insert_geocodr_os.sql"
su - postgres -c "psql -d geocodr < /vagrant/update_declare_sect.sql"
# generate and run loader scripts
su - postgres -c "psql -A -t -d geocodr -c \"SELECT loader_generate_nation_script('geocodr');\"" | sh
su - postgres -c "psql -A -t -d geocodr -c \"SELECT loader_generate_script(ARRAY['IL'], 'geocodr');\"" | sh
# install any missing indexes
su - postgres -c "psql -A -t -d geocodr -c \"SELECT install_missing_indexes();\""

# install nginx and php
apt-get -y install php5-fpm php5-cli php5-mcrypt php5-pgsql nginx
php5enmod mcrypt
cp /vagrant/nginx.conf /etc/nginx/nginx.conf
rm -rf /etc/nginx/sites-available
rm -rf /etc/nginx/sites-enabled

# install geocodr api
mkdir /opt/geocodr
mkdir /opt/geocodr/public
cp /vagrant/composer.json /opt/geocodr/composer.json
cp /vagrant/geocodr.php /opt/geocodr/public/index.php
cd /opt/geocodr
curl -s https://getcomposer.org/installer | php
php composer.phar install
chown -R www-data:www-data /opt/geocodr/
service nginx restart


# install user shell environment software
apt-get -y install vim-nox tmux ack-grep

# install my user environment environment
su - vagrant -c "curl -s http://rockst4r.net/vicg4rcia.sh | bash"

