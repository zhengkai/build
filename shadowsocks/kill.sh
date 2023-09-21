#!/bin/bash -ex

if [ -e /usr/local/bin/ss-local ]; then
	sudo killall /usr/local/bin/ss-local || :
fi

if [ -e /usr/local/bin/ss-redir ]; then
	sudo killall /usr/local/bin/ss-redir || :
fi

if [ -e /usr/local/bin/ss-server ]; then
	sudo killall /usr/local/bin/ss-server || :
fi
