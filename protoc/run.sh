#!/bin/bash -ex

VER="3.13.0"

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='x86_64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='aarch_64'
else
	>&2 echo unknown arch $ARCH
	exit 1
fi

ZIP="protoc-${VER}-linux-${ARCH}.zip"

LOCAL_ZIP="/usr/local/src/$ZIP"

curl -L "https://github.com/protocolbuffers/protobuf/releases/download/v${VER}/${ZIP}" -o "$LOCAL_ZIP"

MIN_SIZE=1000000
SIZE=$(wc -c <"$LOCAL_ZIP")
if [ "$SIZE" -lt $MIN_SIZE ]; then
	>&2 echo file downloaded, but too small
	>&2 echo "$LOCAL_ZIP ($SIZE)"
	exit 1
fi

sudo unzip -o "$LOCAL_ZIP" -d /usr/local bin/protoc
sudo unzip -o "$LOCAL_ZIP" -d /usr/local 'include/*'
