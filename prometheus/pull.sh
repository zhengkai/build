#!/bin/bash -ex

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
    ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
    ARCH='armv7'
else
    >&2 echo "unknown arch $ARCH"
    exit
fi

sudo docker pull "prom/prometheus-linux-${ARCH}:latest"
