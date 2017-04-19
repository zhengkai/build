#!/bin/bash

uid=`id -u shadowsocks 2>/dev/null`

if [ -z "$uid" ]; then
	sudo adduser --system --disabled-password --disabled-login --no-create-home shadowsocks
fi
