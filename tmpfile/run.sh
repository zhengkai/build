#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

sudo cp zhengkai.conf /etc/tmpfiles.d/

if ! sudo grep -q "RuntimeDirectory" "/etc/systemd/system.conf"; then
	sudo sed -i '/^\[Manager\]$/a RuntimeDirectory=/tmp/systemd' /etc/systemd/system.conf
fi
