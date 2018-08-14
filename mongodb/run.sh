#!/bin/bash

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

cd $(dirname `readlink -f $0`)

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

LIST_FILE='/etc/apt/sources.list.d/mongodb.list'
if [ ! -e "$LIST_FILE" ]; then
	sudo cp source.list "$LIST_FILE"
fi
sudo apt update

sudo apt install -y mongodb-org
