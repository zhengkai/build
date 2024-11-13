#!/bin/bash

PACKAGE=${1:-shadowsocks/shadowsocks-rust}

curl "https://api.github.com/repos/${PACKAGE}/releases" 2>/dev/null \
	| jq -r '.[] | .name' - \
	| grep "\." \
	| sort -Vr \
	| head -n 1
