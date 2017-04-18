#!/bin/bash -e

USER='shadowsocks'
CONFIG_FILE='/etc/shadowsocks.json'
PID_FILE='/var/run/ss-local.pid'

if [ ! -e $PID_FILE ]; then
	sudo touch $PID_FILE
	sudo chown $USER $PID_FILE
fi

cd $(dirname `readlink -f $0`)

sudo -u $USER CONFIG_FILE="$CONFIG_FILE" PID_FILE="$PID_FILE" /bin/bash ./client_sub.bash
