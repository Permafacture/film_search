#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# package setup
# 
# @author <ehallmark@asuragen.com>
# ------------------------------------------------


# config
# ------
try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

test_requirements = [
    # TODO: put package test requirements here
]


# files
# -----
with open('README.md') as readme_file:
    readme = readme_file.read()


# exec
# ----
setup(
    name='film_search',
    version='0.0.1',
    description="Data Analysis and Visualization for Internal Development",
    long_description=readme,
    author="Elliot Hallmark",
    author_email='ehallmark@asuragen.com',
    packages=[
        'film_search',
    ],
    test_suite='nosetests',
    tests_require=test_requirements
)
