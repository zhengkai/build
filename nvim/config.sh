#!/bin/bash

echo 'nvim config'

GIT="https://github.com/zhengkai/nvim.git"
LOCAL="${HOME}/.config/nvim"
if [ -d "$LOCAL" ]; then
	(cd "$LOCAL" && git pull)
else
	git clone --depth 1 "$GIT" "$LOCAL"
fi

echo "$LOCAL done"

if command -v npm &>/dev/null; then
	npm i -g bash-language-server
	npm i -g typescript
fi

if command -v go &>/dev/null; then
	go install github.com/mattn/efm-langserver@latest
fi
