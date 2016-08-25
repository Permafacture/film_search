#!/usr/bin/env bash

apt-get update
#apt-get -y upgrade

#Set Up database
## server-dev is required for pyscopg, and version 8.4 is the only one with this package
PG_VERSION=8.4

DB_NAME=asurgen_db
echo "export DATABASE_URI='postgresql:///asurgen_db'" >> ~/.profile

apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION" "postgresql-server-dev-$PG_VERSION"

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER vagrant LOGIN;;

-- Create the database:
CREATE DATABASE $DB_NAME WITH OWNER=vagrant
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;
EOF

#install Python and project python dependencies
apt-get -y install python-dev python-pip python-virtualen libpq-dev

virtualenv asurgen-env
cd asurgen-env
source bin/activate

pip install flask sqlalchemy uwsgi psycopg2

#for authentication
pip install flask-security flask-sqlalchemy
#apt-get -y install nginx git gunicorn
#rm /etc/nginx/sites-enabled/default

#set up app's database tables and fill with initial values
python /vagrant/film_search/initialize.py
