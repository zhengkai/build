#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

GPG_DST="/etc/apt/keyrings/wezterm-fury.gpg"
GPG_SRC="gpg.key"

if [ ! -e "$GPG_DST" ]; then
	if [ ! -e "$GPG_SRC" ]; then
		curl -fsSL https://apt.fury.io/wez/gpg.key -o "$GPG_SRC"
	fi
	sudo gpg --yes --dearmor -o "$GPG_DST" "$GPG_SRC"
fi

echo "deb [signed-by=${GPG_DST}] https://apt.fury.io/wez/ * *" | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update
sudo apt install wezterm
