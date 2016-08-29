* Improve password security
    Install bcrypt < 2.0 and set SECURITY_PASSWORD_HASH to bcrypt
    send password on login over HTTPS
    run uwsgi as www-data instead of vagrant (was having trouble with www-data 
        as a user in postgres because it didn't have permission for the users 
        table, which is the public.user schema.  How to give permission to this
        schema?)

* create /etc/init.d entry for /etc/init/uwsgi.conf service so it can autostart

* Migrations are out of the scope of this project, but a good idea.

* Test site more thuroughly with Phantom.js (currently, javascript is not tested)

* Use temporary database for tests.
