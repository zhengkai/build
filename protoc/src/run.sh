#!/bin/bash -ex

VER="29.3"

cd /usr/local/src

FILE="protobuf-${VER}.tar.gz"

if [ ! -f "$FILE" ]; then
	wget "https://github.com/protocolbuffers/protobuf/releases/download/v${VER}/${FILE}" \
		-O "$FILE"
fi

# tar zxvf "$FILE"

cd "protobuf-${VER}"

bazel build :protoc :protobuf
