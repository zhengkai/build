#! /bin/bash -e

# https://docs.docker.com/install/linux/docker-ce/ubuntu/

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

echo "deb [arch=${ARCH}] https://download.docker.com/linux/ubuntu ${CODENAME} stable" > "$SOURCE"
cat "$SOURCE"
sudo cp "$SOURCE" /etc/apt/sources.list.d/docker.list

sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

sudo apt-key add gpg.key
sudo apt update
sudo apt install -y docker-ce
