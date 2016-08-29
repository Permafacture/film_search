#!/usr/env/python
'''
Instantiate database tables and initial values
'''
from app import db, user_datastore, app
from flask_security.utils import encrypt_password as ep

with app.app_context():
    db.drop_all()
    db.create_all()
    user_datastore.create_role(name='admin')
    user_datastore.create_user(email='permafacture@gmail.com', 
            password=ep('password'), roles=['admin'])
    user_datastore.create_user(email='rzeigler@asuragen.com', 
            password=ep('password'), roles=['admin'])
    user_datastore.create_user(email='joe@gmail.com', password=ep('password'))

    db.session.commit()

