#!/bin/bash

USER='shadowsocks'
PID=`cat /var/run/ss-local.pid`

if [ "$PID" -le 0 ]; then
	>&2 echo 'pid not found'
	exit
fi

echo 'kill '$PID
sudo -u $USER kill $PID
