#!/bin/bash

# https://docs.docker.com/install/linux/docker-ce/ubuntu/

cd $(dirname `readlink -f $0`)

sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

sudo apt-key add gpg.key

LIST_FILE='/etc/apt/sources.list.d/docker.list'
if [ ! -e "$LIST_FILE" ]; then
	sudo cp source.list "$LIST_FILE"
fi
sudo apt update

sudo apt install -y docker-ce
