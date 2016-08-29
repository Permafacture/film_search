import os
import config_vars
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    DEBUG = False
    TESTING = False
    WTF_CSRF_ENABLED = True #CSRF_ENABLED = True
    SECRET_KEY = 'just_a_SECRET_key'
    SQLALCHEMY_DATABASE_URI = config_vars.DATABASE_URI
    SQLALCHEMY_TRACK_MODIFICATIONS = False 
    SECURITY_PASSWORD_HASH = 'sha512_crypt'
    SECURITY_PASSWORD_SALT = "Always_salt_ur_hashes!"
    SECURITY_REGISTERABLE = True
    SECURITY_TRACKABLE = True
    SECURITY_SEND_REGISTER_EMAIL=False

class TestingConfig(Config):
    TESTING = True
    WTF_CSRF_ENABLED = False #CSRF_ENABLED = False
    #Use a memory backed database for faster tests
