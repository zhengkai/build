#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

sudo touch /etc/default/php-fpm
sudo cp php-fpm.service /etc/systemd/system/php-fpm.service
sudo cp php-fpm-checkconf /usr/lib/php/php-fpm-checkconf
sudo cp php-fpm /etc/init.d/php-fpm
sudo update-rc.d php-fpm defaults
