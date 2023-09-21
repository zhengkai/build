#!/bin/bash -ex

# via https://askubuntu.com/questions/886620/how-can-i-execute-command-on-startup-rc-local-alternative-on-ubuntu-16-10

DIR=$(readlink -f "$0") && DIR=$(dirname "$DIR") && cd "$DIR" || exit 1

if [ ! -e /etc/systemd/system/rc-local.service ]; then
	sudo cp service /etc/systemd/system/rc-local.service
fi

if [ ! -e /etc/rc.local ]; then
	sudo cp rc.local /etc/rc.local
	sudo chmod +x /etc/rc.local
fi

if [ ! -e /sbin/run-rc-local.sh ]; then
	sudo cp run-rc-local.sh /sbin/run-rc-local.sh
	sudo chmod +x /sbin/run-rc-local.sh
fi

sudo systemctl enable rc-local

sudo systemctl start rc-local.service
sudo systemctl status rc-local.service
