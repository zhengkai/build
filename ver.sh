#!/bin/bash

DIR_LIST=('git' 'go' 'nodejs' 'shadowsocks' 'vim' 'nvim')

for DIR in "${DIR_LIST[@]}"; do
	STATUS='not installed'
	FILE=$DIR'/ver.txt'
	if [ -s "$FILE" ]; then
		STATUS=$(cat "$FILE" || :)
	fi
	printf '%20s  %s\n' "$DIR" "$STATUS"
	echo
done
