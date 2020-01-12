#!/bin/bash

BIN="$HOME/conf/bin/acl"
if [ ! -x "$BIN" ]; then
	>&2 echo no acl
	exit
fi

"$BIN" sudo "/usr/local"
