#!/bin/bash -e

GPG_FILE="/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg"
if [ ! -f "$GPG_FILE" ]; then
	curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
		| sudo gpg --dearmor -o "$GPG_FILE"
fi

ARCH=$(dpkg --print-architecture)
APT_FILE="/etc/apt/sources.list.d/nvidia-container-toolkit.list"
if [ ! -f "$APT_FILE" ]; then
	echo "deb [signed-by=${GPG_FILE}] https://nvidia.github.io/libnvidia-container/stable/deb/${ARCH} /" | sudo tee "$APT_FILE"
fi
