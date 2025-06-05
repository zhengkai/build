#!/bin/bash

PACKAGE=${1:-erebe/wstunnel}

curl "https://api.github.com/repos/${PACKAGE}/releases" 2>/dev/null \
	| jq -r '.[] | .name' - \
	| grep "\." \
	| sort -Vr \
	| head -n 1
