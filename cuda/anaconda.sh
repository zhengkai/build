#!/bin/bash

sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

FILE="/usr/local/src/anaconda3.sh"
if [ ! -f "$FILE" ]; then
	wget 'https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh' -O "$FILE"
fi

chmod +x "$FILE"
"$FILE"
