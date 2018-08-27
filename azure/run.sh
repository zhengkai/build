#!/bin/bash

# https://docs.microsoft.com/zh-cn/cli/azure/install-azure-cli-apt?view=azure-cli-latest

cd $(dirname `readlink -f $0`)

sudo apt-key add microsoft.asc

LIST_FILE='/etc/apt/sources.list.d/azure.list'
if [ ! -e "$LIST_FILE" ]; then
	sudo cp source.list "$LIST_FILE"
fi
sudo apt update

sudo apt-get install -y azure-cli
