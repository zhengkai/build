#!/bin/bash -e

CONFIG_FILE='/etc/shadowsocks.json'
if [ ! -s $CONFIG_FILE ]; then
	>&2 echo 'no config file '$CONFIG_FILE
	exit 1
fi

TYPE="${1,,}"

if [ "$TYPE" == 'client' ]; then
	TYPE='local'
fi

case "$TYPE" in
	local)
		CHECK='server'
		;;
	server)
		CHECK='local'
		;;
	*)
		>&2 echo 'Usage: /install.sh {local|server}'
		exit 1
		;;
esac

TYPE="ss-$TYPE"
CHECK="ss-$CHECK"

if [ -e "/etc/init.d/$CHECK" ]; then
	>&2 echo "ERROR: $CHECK installed"
	exit 1
fi

cd $(dirname `readlink -f $0`)

TARGET="/etc/init.d/$TYPE"

sudo cp $TYPE $TARGET
sudo chmod +x $TARGET

sudo update-rc.d -f $TYPE remove

sudo update-rc.d $TYPE defaults

sudo update-rc.d $TYPE enable

sudo $TARGET start
