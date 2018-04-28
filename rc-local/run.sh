#!/bin/bash -ex

cd $(dirname `readlink -f $0`)

if [ ! -e /etc/systemd/system/rc-local.service ]; then
	sudo cp rc-local.service /etc/systemd/system/rc-local.service
fi

if [ ! -e /etc/rc.local ]; then
	sudo cp rc.local /etc/rc.local
	sudo chmod +x /etc/rc.local
fi

sudo systemctl enable rc-local

sudo systemctl start rc-local.service
sudo systemctl status rc-local.service
