#!/bin/bash -x

check_user='shadowsocks'

ulimit -n 51200

user=`id -u -n`
if [ "$user" != "$check_user" ]; then
	>&2 echo 'must be user '$check_user
	exit 1
fi

/usr/local/bin/ss-local -c /etc/shadowsocks.json
