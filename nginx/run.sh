#! /bin/bash

sudo cp nginx.list /etc/apt/sources.list.d/
sudo apt-key add nginx_signing.key
sudo apt-get update
sudo apt-get install -y nginx
