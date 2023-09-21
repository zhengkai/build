#!/bin/bash -ex

# https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html

SRC="/usr/local/src/opencv"

sudo apt update
sudo apt install -y cmake g++ wget unzip

mkdir -p "${SRC}/build"

cd "$SRC"

if [ ! -d opencv-master ]; then
	wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
	unzip opencv.zip
fi

cd build

cmake  ../opencv-master
cmake --build .
