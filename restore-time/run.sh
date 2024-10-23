#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

BASH_FILE="/usr/local/bin/restore-time"
if [ ! -e "$BASH_FILE" ]; then
	sudo cp ./restore-time "$BASH_FILE"
fi

SERVICE="restore-time.service"
SERVICE_FILE="/etc/systemd/system/${SERVICE}"
if [ ! -e "$SERVICE_FILE" ]; then
	sudo cp ./service "$SERVICE_FILE"
fi

sudo systemctl enable "$SERVICE"
sudo systemctl start  "$SERVICE"
