#!/usr/bin/env bash
# PG_VERSION=9.1
# DATABASE_NAME=asurgen_db
# DATABASE_URI='postgresql:///asurgen_db'

application_user="vagrant"
USER_HOME="/home/$application_user"
CONF_DEST="/etc/vminterface"
sysctl -p #load the above values

useradd -m -p agPn3A7.oJSI $application_user

# Utilities
function die {
   echo $1
   exit 1
}

function section {
    echo
    echo $1
    echo
}


echo " ### install Python and project python dependencies ### "
apt-get update
apt-get -y install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools python3-venv nginx

echo " ### install and set up nginx ### "
rm /etc/nginx/sites-enabled/default
mkdir -p /var/www/film_search
cp -r /vagrant/* /var/www/
find /var/www/ -type f -name '*.pyc' -delete
find /var/www/ -type f -name '*.swp' -delete
ln -s /var/www/film_search_nginx.conf /etc/nginx/conf.d/
mkdir -p /var/log/uwsgi
touch /var/log/uwsgi/uwsgi.log
chown $application_user /var/log/uwsgi/uwsgi.log
rm -rf /etc/systemd/system/film_search.service
mv /var/www/film_search.service /etc/systemd/system/
mkdir -p /etc/uwsgi/vassals
rm -rf /etc/uwsgi/vassals/uwsgi.ini
ln -s /var/www/film_search_uwsgi.ini /etc/uwsgi/vassals/uwsgi.ini
chown -R vagrant:vagrant /var/www/
chown -R vagrant:vagrant /var/log/uwsgi/

section "set up python dependancies"
sudo -iu $application_user bash << EOF

if [ ! -e "$USER_HOME/env" ] ; then
    python3.6 -m venv $USER_HOME/env/ || die "Failed to create virtualenvironment"
fi

source $USER_HOME/env/bin/activate 
pip install --upgrade pip
pip install wheel
pip install -r /vagrant/requirements.txt
pip install -e /vagrant/



#set up app's database tables and fill with initial values
echo "DATABASE_URI='$DATABASE_URI'" >> /var/www/film_search/config_vars.py
python /var/www/film_search/initialize.py
EOF

service nginx restart
service film_search start

echo "\n\n"
echo "  Done building. To run tests:"
echo "      cd /var/www/film_search && python -m unittest discover && python initialize.py"
