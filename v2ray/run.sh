#!/bin/bash

if [ ! -e /usr/bin/v2ray ]; then
	sudo apt install v2ray
fi

if ! sudo id -u v2ray &>/dev/null; then
    sudo useradd -r -s /usr/sbin/nologin -d /var/lib/v2ray v2ray
fi

LIMIT_FILE="/etc/security/limits.d/v2ray.conf"
if [ ! -e "$LIMIT_FILE" ]; then
	{
		echo "v2ray   -   nofile   524288"
		echo "v2ray   -   nproc    249753"
	} | sudo tee -a "$LIMIT_FILE"
fi
