#!/bin/bash -e

cd $(dirname `readlink -f $0`)

sudo apt-get install -y libsystemd-dev

if [ ! -d '/lib/systemd/system' ]; then
	>&2 echo 'systemd not found'
	exit 1
fi

USYSD='/usr/lib/systemd/system'
if [ ! -d $USYSD ]; then
	sudo mkdir -p $USYSD
fi

FILE='php-fpm.service'

sudo mkdir -p /var/log/php

sudo cp $FILE $USYSD'/'$FILE
sudo ln -s $USYSD'/'$FILE '/etc/systemd/system/'$FILE

sudo cp php-fpm-checkconf /usr/lib/php/php-fpm-checkconf
sudo cp php-fpm /etc/init.d/php-fpm

sudo update-rc.d php-fpm defaults
sudo update-rc.d php-fpm enable
