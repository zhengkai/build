#!/bin/bash -e

sudo apt install -y libdbus-1-dev libxcursor-dev libxrandr-dev libxi-dev libxinerama-dev libgl1-mesa-dev libxkbcommon-x11-dev libfontconfig-dev \
	libharfbuzz-dev liblcms2-dev libx11-xcb-dev libwayland-dev wayland-protocols

cd /usr/local/src

if [ ! -d kitty ]; then
	git clone https://github.com/kovidgoyal/kitty.git
fi

cd kitty

make clean || :
git pull --rebase
make

sudo cp ./kitty/launcher/kitty /usr/local/bin
sudo cp terminfo/x/xterm-kitty /usr/share/terminfo/x/
