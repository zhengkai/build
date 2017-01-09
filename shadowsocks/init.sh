#!/bin/bash

uid=`id -u shadowsocks 2>/dev/null || echo ''`

if [ -z "$uid" ]; then
	sudo adduser --system --disabled-password --disabled-login --no-create-home shadowsocks
fi

sudo touch /var/run/ss-local.pid
sudo chown shadowsocks /var/run/ss-local.pid

sudo touch /var/run/ss-server.pid
sudo chown shadowsocks /var/run/ss-server.pid
