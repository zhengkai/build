#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

sudo apt-get install libsystemd-dev

sudo mkdir -p /var/log/php

sudo cp php-fpm.service /etc/systemd/system/php-fpm.service
sudo cp php-fpm-checkconf /usr/lib/php/php-fpm-checkconf
sudo cp php-fpm /etc/init.d/php-fpm

sudo update-rc.d php-fpm defaults
sudo update-rc.d php-fpm enable
