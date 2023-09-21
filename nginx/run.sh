#! /bin/bash -e

GPG_FILE="/usr/share/keyrings/nginx.gpg"

CODENAME=$(lsb_release -c -s)

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo unknown arch $ARCH
	exit
fi

DIR=$(readlink -f "$0") && DIR=$(dirname "$DIR") && cd "$DIR" || exit 1

SOURCE='source.list'

echo "deb [arch=${ARCH} signed-by=${GPG_FILE}] http://nginx.org/packages/ubuntu/ ${CODENAME} nginx" > "$SOURCE"
echo "deb-src [arch=${ARCH} signed-by=${GPG_FILE}] http://nginx.org/packages/ubuntu/ ${CODENAME} nginx" >> "$SOURCE"
cat "$SOURCE"
sudo cp "$SOURCE" /etc/apt/sources.list.d/nginx.list

if [ ! -e /usr/share/keyrings/nginx.gpg ]; then
	curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee "$GPG_FILE" >/dev/null
fi
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

sudo cp nginx.conf /etc/nginx/
