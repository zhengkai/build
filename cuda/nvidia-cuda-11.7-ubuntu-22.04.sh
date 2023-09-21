#!/bin/bash

PIN="/etc/apt/preferences.d/cuda-repository-pin-600"
if [ ! -e "$PIN" ]; then
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
	sudo mv cuda-ubuntu2204.pin "$PIN"
fi

DEB="cuda-repo-ubuntu2204-11-7-local_11.7.1-515.65.01-1_amd64.deb"
if [ ! -e "$DEB" ]; then
	wget "https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/${DEB}"
	sudo dpkg -i "$DEB"
	sudo cp /var/cuda-repo-ubuntu2204-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
fi

sudo apt-get update
sudo apt-get -y install cuda
