#!/bin/bash -e

sudo apt install -y libdbus-1-dev libxcursor-dev libxrandr-dev libxi-dev \
	libxinerama-dev libgl1-mesa-dev libxkbcommon-x11-dev libfontconfig-dev \
	libharfbuzz-dev liblcms2-dev libx11-xcb-dev libwayland-dev librsync-dev \
	libxxhash-dev wayland-protocols

# 这俩其实安装 kitty 本身用不到，但用 kitty 时肯定会用到
sudo apt install -y xclip xdotool

cd /usr/local/src

if [ ! -d kitty ]; then
	git clone https://github.com/kovidgoyal/kitty.git
fi

cd kitty

make clean || :
git pull --rebase

PROCESSOR=$(grep -c '^processor' /proc/cpuinfo)
make -j "$PROCESSOR"

sudo cp ./kitty/launcher/kitty /usr/local/bin
sudo cp terminfo/x/xterm-kitty /usr/share/terminfo/x/
