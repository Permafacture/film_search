from flask import url_for
from flask_testing import TestCase
from flask_security.utils import encrypt_password as ep

from app import app, db, user_datastore

class BaseTestCase(TestCase):
    """A base test case for flask-tracking."""

    def create_app(self):
        app.config.from_object('config.TestingConfig')
        return app

    def setUp(self):
        db.drop_all()
        db.create_all()
        db.session.commit()

    def tearDown(self):
        db.session.remove()
        db.drop_all()

    def create_user(self,username,password):
        user_datastore.create_user(email=username, password=ep(password))
        db.session.commit()

    def create_admin(self,username,password):
        user_datastore.create_role(name='admin')
        user_datastore.create_user(email=username, password=ep(password),roles=['admin'])
        db.session.commit()

    def login(self, username, password):
        return self.client.post(url_for('security.login'), data=dict(
            email=username,
            password=password))

    def logout(self):
        return self.client.get(url_for('security.logout'), follow_redirects=True)


class UserViewsTests(BaseTestCase):
    def test_users_can_login(self):
        self.create_user('joe@gmail.com','password')
        response = self.login('joe@gmail.com','password')
        self.assert_redirects(response, url_for('home'))

    def test_wrong_password_fails_login(self):
        self.create_user('joe@gmail.com','password')
        response = self.login('joe@gmail.com','PASSWORD')
        assert "Invalid password" in response.data

    def test_wrong_username_fails_login(self):
        response = self.login('joe@gmail.com','password')
        assert "user does not exist" in response.data

    def test_admins_can_login(self):
        self.create_admin('joe@gmail.com','password')
        response = self.login('joe@gmail.com','password')
        self.assert_redirects(response, url_for('home'))

    def test_admins_can_see_admin_page(self):
        self.create_admin('joe@gmail.com','password')
        with self.client:
            self.login('joe@gmail.com','password')
            response = self.client.get(url_for('admin'))
            assert "Last IP" in response.data

    def test_users_cannot_see_admin_page(self):
        self.create_user('joe@gmail.com','password')
        with self.client:
            self.login('joe@gmail.com','password')
            response = self.client.get(url_for('admin'))
            assert "Last IP" not in response.data

    def test_can_register_new_users(self):
        response = self.client.post(url_for('security.register'),data=dict(
             email='joe@joe.com',
             password = 'password',
             password_confirm = 'password'))
        self.assert_redirects(response, url_for('home'))

