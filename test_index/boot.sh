#!/bin/bash

mysqladmin -u root -p123456 drop test_index
mysqladmin -u root -p123456 create test_index
mysql -u root -p123456 test_index < prepare.sql

./test_data.py
