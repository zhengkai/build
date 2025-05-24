#!/bin/bash -ex

cd /usr/local/src || exit 1

if [ ! -d vcpkg ]; then
	git clone https://github.com/microsoft/vcpkg.git
	exit
fi

cd vcpkg || exit 1
git pull
