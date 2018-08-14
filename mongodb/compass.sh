#!/bin/bash

wget https://downloads.mongodb.com/compass/mongodb-compass_1.14.6_amd64.deb

sudo dpkg -i mongodb-compass_1.14.6_amd64.deb

DEBUG=* mongodb-compass
