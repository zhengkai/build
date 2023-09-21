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

COPILOT="${LOCAL}/pack/github/start/copilot.vim"
if [ -d "$COPILOT" ]; then
	(cd "$COPILOT" && git pull)
else
	git clone --depth 1 https://github.com/github/copilot.vim.git "$COPILOT"
fi

echo "$COPILOT done"
