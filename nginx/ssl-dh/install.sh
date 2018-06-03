#!/bin/bash

cd $(dirname `readlink -f $0`)

CONF_DIR='/etc/nginx/conf.d'

if [ ! -d "$CONF_DIR" ]; then
	echo 'Nginx not found'
	exit
fi

DH_FILE='/etc/nginx/dh4096.pem'
if [ ! -e $DH_FILE ]; then
	sudo openssl dhparam -out $DH_FILE 4096
fi

sudo cp perfect-forward-secrecy.conf $CONF_DIR'/'
