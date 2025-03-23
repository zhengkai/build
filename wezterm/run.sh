#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

if [ ! -e gpg.key ]; then
	curl -fsSL https://apt.fury.io/wez/gpg.key
fi
sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg gpg.key

echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
