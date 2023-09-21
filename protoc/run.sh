#!/bin/bash -e

VER=$(curl -s -H "Accept: application/vnd.github.v3+json" \
	https://api.github.com/repos/protocolbuffers/protobuf/releases \
	| jq -r '.[0].tag_name')

echo "$VER"

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='x86_64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='aarch_64'
else
	>&2 echo unknown arch $ARCH
	exit 1
fi

ZIP="protoc-${VER##v}-linux-${ARCH}.zip"

LOCAL_ZIP="/usr/local/src/$ZIP"

set -x

curl -s -L "https://github.com/protocolbuffers/protobuf/releases/download/${VER}/${ZIP}" -o "$LOCAL_ZIP"

MIN_SIZE=1000000
SIZE=$(wc -c <"$LOCAL_ZIP")
if [ "$SIZE" -lt $MIN_SIZE ]; then
	>&2 echo file downloaded, but too small
	>&2 echo "$LOCAL_ZIP ($SIZE)"
	exit 1
fi

sudo unzip -o "$LOCAL_ZIP" -d /usr/local bin/protoc
sudo unzip -o "$LOCAL_ZIP" -d /usr/local 'include/*'
