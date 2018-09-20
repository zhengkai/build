#! /bin/bash

cd $(dirname `readlink -f $0`)

sudo cp source.list /etc/apt/sources.list.d/nginx.list
sudo apt-key add nginx-signing.key
sudo apt update
sudo apt install -y nginx

if [ -e '/etc/nginx/fastcgi_params' ]; then
	check_param=`grep 'SCRIPT_FILENAME' /etc/nginx/fastcgi_params`
	if [ -z "$check_param" ]; then
		echo -e "\n"'fastcgi_param  SCRIPT_FILENAME    $request_filename;' | sudo tee -a /etc/nginx/fastcgi_params
	fi
fi

sudo mkdir -p /etc/nginx/ssl.d
sudo mkdir -p /etc/nginx/vhost.d

sudo cp nginx.conf /etc/nginx/
