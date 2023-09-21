#!/bin/bash -ex

VER=$(/usr/sbin/nginx -v 2>&1 || :)

NGINX_VER="${VER##*\/}"
if [ -z "$NGINX_VER" ]; then
	echo nginx ver not found
	exit
fi

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

CURRENT_VER=''
VER_FILE="${DIR}/ver.txt"
if [ -f "$VER_FILE" ]; then
	CURRENT_VER=$(cat "$VER_FILE")
fi
if [ "$CURRENT_VER" == "$NGINX_VER" ]; then
	echo
	echo "newest version '$NGINX_VER', no need update"
	echo
	exit
fi

TARGET="/etc/nginx/modules"
BR_DIR="ngx_brotli"
SRC_DIR="/usr/local/src"

sudo apt install -y libpcre3-dev

cd "$SRC_DIR"

NGINX_NAME="nginx-${NGINX_VER}"
NGINX_TGZ="${NGINX_NAME}.tar.gz"

if [ ! -d "$NGINX_NAME" ]; then
	curl "https://nginx.org/download/${NGINX_TGZ}" -o "$NGINX_TGZ"
	tar xzf "$NGINX_TGZ"
fi

if [ ! -d "$BR_DIR" ]; then
	git clone "https://github.com/google/ngx_brotli.git"
fi
(
	cd "$BR_DIR"
	git pull
	git submodule update --init --recursive
)

cd "$NGINX_NAME"

make clean >/dev/null 2>&1 || :

./configure --with-compat --add-dynamic-module="${SRC_DIR}/${BR_DIR}"

make modules

sudo service nginx stop || :

sudo cp objs/ngx_http_brotli_filter_module.so "$TARGET"
sudo cp objs/ngx_http_brotli_static_module.so "$TARGET"

echo "$NGINX_VER" > "$VER_FILE"

sudo service nginx start || :
