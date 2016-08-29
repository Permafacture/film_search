#!/usr/bin/env bash
PG_VERSION=9.1
DATABASE_NAME=asurgen_db
DATABASE_URI='postgresql:///asurgen_db'

sysctl -p #load the above values

apt-get update

echo " ### Set Up database ### "
echo "export DATABASE_URI=$DATABASE_URI" >> /home/vagrant/.bashrc

apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION" "postgresql-server-dev-$PG_VERSION"

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER vagrant LOGIN;;

-- Create the database:
CREATE DATABASE $DATABASE_NAME WITH OWNER=vagrant
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;
EOF




echo " ### install Python and project python dependencies ### "
apt-get -y install python-dev python-pip python-virtualenv libpq-dev

pip install -r /vagrant/requirements.txt   #No virtualenv. 


echo " ### install and set up nginx ### "
apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
mkdir -p /var/www/film_search
cp -r /vagrant/* /var/www/
find /var/www/ -type f -name '*.pyc' -delete
find /var/www/ -type f -name '*.swp' -delete
ln -s /var/www/film_search_nginx.conf /etc/nginx/conf.d/
mkdir -p /var/log/uwsgi
mv /var/www/film_search_uwsgi.conf /etc/init/uwsgi.conf
mkdir -p /etc/uwsgi/vassals
ln -s /var/www/film_search_uwsgi.ini /etc/uwsgi/vassals/uwsgi.ini
chown -R vagrant:vagrant /var/www/
chown -R vagrant:vagrant /var/log/uwsgi/

#set up app's database tables and fill with initial values
echo "DATABASE_URI='$DATABASE_URI'" >> /var/www/film_search/config_vars.py
sudo -u vagrant python /var/www/film_search/initialize.py

service nginx restart
service uwsgi start

echo "\n\n"
echo "  Done building. To run tests:"
echo "      cd /var/www/film_search && python -m unittest discover && python initialize.py"

