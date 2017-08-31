#!/bin/bash

apt -y install mariadb-server
apt -y install libmysqlclient-dev
pip install mysql-python
pip install mysql-connector==2.1.3
