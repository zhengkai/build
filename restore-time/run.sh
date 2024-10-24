#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

NAME="restore-time"

BASH_FILE="/usr/local/bin/${NAME}"
if [ ! -e "$BASH_FILE" ]; then
	sudo cp ./restore-time "$BASH_FILE"
fi

SERVICE="${NAME}.service"
SERVICE_FILE="/etc/systemd/system/${SERVICE}"
if [ ! -e "$SERVICE_FILE" ]; then
	sudo cp ./service "$SERVICE_FILE"
fi

CRON="/etc/cron.d/${NAME}"
if [ ! -e "$CRON" ]; then
	sudo cp ./crontab "$CRON"
fi

sudo systemctl enable "$SERVICE"
sudo systemctl start  "$SERVICE"
