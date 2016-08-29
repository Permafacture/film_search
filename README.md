Existing admin users:
    'permafacture@gmail.com','password'
    'rzeigler@asuragen.com','password'

Existing non-admin users
    'joe@gmail.com','password'

Run tests with

    vagrant ssh
    cd /var/www/film_search/
    python -m unittest discover && python initialize.py

Visit site at 127.0.0.1:8080
