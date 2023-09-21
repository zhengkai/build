#!/bin/bash -ex

sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl

if [ ! -e /usr/bin/python ]; then
	sudo ln -s /usr/bin/python3 /usr/bin/python
fi

sudo chmod a+rx /usr/local/bin/youtube-dl
