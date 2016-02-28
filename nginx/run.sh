#! /bin/bash

sudo apt-mark hold nginx-common
sudo apt-mark hold nginx-core

sudo cp nginx.list /etc/apt/sources.list.d/
sudo apt-key add nginx_signing.key
sudo apt-get update
sudo apt-get install -y nginx

if [ -e '/etc/nginx/fastcgi_params' ]; then
	check_param=`grep 'SCRIPT_FILENAME' /etc/nginx/fastcgi_params`
	if [ -z "$check_param" ]; then
		echo -e "\n"'fastcgi_param  SCRIPT_FILENAME    $request_filename;' | sudo tee -a /etc/nginx/fastcgi_params
	fi
fi
