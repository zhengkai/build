#! /bin/bash -ex

sudo sed -i 's/^#NAutoVTs=[0-9]\+$/NAutoVTs=3/g' /etc/systemd/logind.conf

TTY_SERVICE="/lib/systemd/system/getty@.service"
if [ -f "$TTY_SERVICE" ]; then
	sudo ln -sf "$TTY_SERVICE" /etc/systemd/system/getty.target.wants/getty@tty2.service
	sudo ln -sf "$TTY_SERVICE" /etc/systemd/system/getty.target.wants/getty@tty3.service
fi
