#! /bin/bash -e

GPG_FILE="/usr/share/keyrings/nginx.gpg"

REPO_URL="http://nginx.org/packages/ubuntu/ "

CODENAME=$(lsb_release -c -s 2>/dev/null)

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo "unknown arch $ARCH"
	exit
fi

cd "$(dirname "$(readlink -f "$0")")" || exit 1

if [ ! -e "$GPG_FILE" ]; then
	sudo cp nginx.gpg "$GPG_FILE"
fi

SOURCE='source.list'

REPO="[arch=${ARCH} signed-by=${GPG_FILE}] $REPO_URL $CODENAME nginx"

echo "deb $REPO" > "$SOURCE"
echo "deb-src $REPO" >> "$SOURCE"
cat "$SOURCE"
sudo cp "$SOURCE" /etc/apt/sources.list.d/nginx.list

sudo apt update
sudo apt install -y nginx

# if [ -e '/etc/nginx/fastcgi_params' ]; then
# 	check_param=$(grep 'SCRIPT_FILENAME' /etc/nginx/fastcgi_params || :)
# 	if [ -z "$check_param" ]; then
# 		echo -e "\nfastcgi_param  SCRIPT_FILENAME    \$request_filename;" | sudo tee -a /etc/nginx/fastcgi_params
# 	fi
# fi

sudo mkdir -p /etc/nginx/ssl.d
sudo mkdir -p /etc/nginx/vhost.d
sudo mkdir -p /etc/nginx/conf.d

sudo cp --update=none base.conf /etc/nginx/conf.d/

if id nginx &>/dev/null; then
	if getent group www-data &>/dev/null; then
		sudo adduser nginx www-data || :
	fi
fi
