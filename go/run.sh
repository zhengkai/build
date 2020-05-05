#!/bin/bash -e

GO_SITE='https://dl.google.com/go/'
#GO_SITE='https://mirrors.ustc.edu.cn/golang/'

cd "$(dirname "$(readlink -f "$0")")" || exit 1

if [ -e /usr/local/go/bin/go ]; then
	/usr/local/go/bin/go version || :
fi

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo unknown arch $ARCH
	exit
fi

exec 200>"update-bin.lock"
flock -x -n 200 || {
	>&2 echo
	>&2 echo "$0 is running"
	exit 1
}

CHECK_VER=$(./get-ver.sh)
if [ -z "$CHECK_VER" ]; then
	>&2 echo 'can not detect go version'
	exit 1
fi

CURRENT_VER=''
VER_FILE='ver.txt'
if [ -f "$VER_FILE" ]; then
	CURRENT_VER=$(cat ver.txt)
fi
if [ "$CURRENT_VER" == "$CHECK_VER" ]; then
	echo
	echo "newest version '$CHECK_VER', no need update"
	echo
	exit
fi

GOBIN_NAME="go${CHECK_VER}.linux-${ARCH}.tar.gz"
GOBIN_FILE="/tmp/${GOBIN_NAME}"
if ! [ -e "$GOBIN_FILE" ]; then
	wget "${GO_SITE}${GOBIN_NAME}" -O "$GOBIN_FILE"
fi

if [ -e /usr/local/go ]; then
	sudo rm -rf /usr/local/go
fi
sudo tar -C /usr/local -xzf "$GOBIN_FILE"

if [ ! -e /usr/local/bin/go ]; then
	sudo ln -s /usr/local/go/bin/go /usr/local/bin/ || :
fi
if [ ! -e /usr/local/bin/gofmt ]; then
	sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/ || :
fi

/usr/local/go/bin/go version
echo "$CHECK_VER" > "$VER_FILE"

if [ -n "$CURRENT_VER" ]; then
	echo
	echo "golang upgraded from $CURRENT_VER to $CHECK_VER"
	echo
fi
