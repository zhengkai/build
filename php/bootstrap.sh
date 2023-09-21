#!/bin/bash

#
# 确保用户非 root、在 sudo 组
#
# 确保 /usr/local/src 在 POSIX ACL 里是 sudo 组可写
#

SRC_PATH='/usr/local/src'

if [ $(id -u) == 0 ]; then
	echo "don't use root" >&2
	exit 1
fi

ID=`id`
SUDO_SEARCH="(sudo)"
if [ "${ID##*$SUDO_SEARCH*}" ]; then
	echo 'not in sudo group' >&2
	exit 1
fi

if ! [ -w "$SRC_PATH" ]; then
	sudo setfacl -d -R -m g:sudo:rwx $SRC_PATH
	sudo setfacl    -R -m g:sudo:rwX $SRC_PATH
fi

if ! [ -w "$SRC_PATH" ]; then
	echo 'can not write '$SRC_PATH >&2
	exit 1
fi
