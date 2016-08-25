#!/usr/env/python
'''
Instantiate database tables and initial values
'''
from app import db, user_datastore
db.create_all()
user_datastore.create_role(name='admin')
user_datastore.create_user(email='permafacture@gmail.com', password='password', roles=['admin'])
user_datastore.create_user(email='rzeigler@asuragen.com', password='password', roles=['admin'])
user_datastore.create_user(email='joe@gmail.com', password='password')

db.session.commit()

