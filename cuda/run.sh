#! /bin/bash

REP_FILE="/etc/apt/preferences.d/cuda-repository-pin-600"
if [ ! -f "$REP_FILE" ]; then
	TMP_FILE="/tmp/cuda-ubuntu1804.pin"
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin -O "$TMP_FILE"
	sudo cp "$TMP_FILE" "$REP_FILE"
fi

sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
