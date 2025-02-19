#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

if command -v npm &>/dev/null; then
	if [ ! -e ~/.npm/bin/bash-language-server ]; then
		npm i -g bash-language-server
	fi

	if [ ! -e ~/.npm/bin/typescript-language-server ]; then
		npm install -g typescript-language-server typescript
	fi
fi

if [ ! -e /usr/local/lib/lua-ls ]; then
	../lua-ls/run.sh
fi

if command -v go &>/dev/null; then
	if [ ! -f /go/bin/efm-langserver ]; then
		go install github.com/mattn/efm-langserver@latest
	fi
	if [ ! -f /go/bin/gopls ]; then
		go install golang.org/x/tools/gopls@latest
	fi
fi
