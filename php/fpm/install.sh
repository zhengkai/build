#!/bin/bash

cd $(dirname `readlink -f $0`)

sudo apt-get install -y libsystemd-dev

sudo mkdir -p /var/log/php

sudo cp php-fpm.service /usr/lib/systemd/system/php-fpm.service
sudo ln -s /usr/lib/systemd/system/php-fpm.service /etc/systemd/system/php-fpm.service
sudo cp php-fpm-checkconf /usr/lib/php/php-fpm-checkconf
sudo cp php-fpm /etc/init.d/php-fpm

sudo update-rc.d php-fpm defaults
sudo update-rc.d php-fpm enable
