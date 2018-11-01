#! /bin/bash

cd $(dirname `readlink -f $0`)

sudo cp source.list /etc/apt/sources.list.d/git-lfs.list
sudo apt-key add gpg.key
sudo apt update

sudo apt install -y git-lfs
