#!/bin/bash

DIR=`readlink -f "$0"` && DIR=`dirname "$DIR"` && cd "$DIR" || exit 1

if [ ! -e 'wudao-dict' ]; then
	git clone https://github.com/chestnutheng/wudao-dict
fi

sudo -H pip3 install bs4
sudo -H pip3 install lxml

mkdir -p wudao-dict/wudao-dict/usr

echo '#! /bin/bash'> ./dict-bin
echo "cd '${DIR}/wudao-dict/wudao-dict'" >> ./dict-bin
echo './wdd $*' >> ./dict-bin

sudo cp ./dict-bin /usr/local/bin/dict
sudo chmod +x /usr/local/bin/dict
sudo cp ./wudao-dict/wudao-dict/wd_com /etc/bash_completion.d/wd
. /etc/bash_completion.d/wd
