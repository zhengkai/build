#!/bin/bash -ex

APP="mpv"

GPG_DIR="/etc/apt/trusted.gpg.d"
GPG_FILE="fruit.gpg"
GPG_FILE_LOCAL="${GPG_DIR}/${GPG_FILE}"
APT_FILE="/etc/apt/sources.list.d/fruit.list"

if [ -f "$APT_FILE" ]; then
	echo "Fruit APT source already exists. Exiting."
	exit 0
fi

if [ ! -f "$GPG_FILE_LOCAL" ]; then
	sudo curl --output-dir "$GPG_DIR" -O "https://apt.fruit.je/$GPG_FILE"
fi

CODE=$(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2)

echo "deb [signed-by=${GPG_FILE_LOCAL}] https://apt.fruit.je/ubuntu $CODE $APP" \
	| sudo tee "$APT_FILE"
