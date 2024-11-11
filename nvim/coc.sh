#!/bin/bash

# neovim 配置完成后需要安装的第三方软件

# :CocInstall coc-tsserver

npm i -g bash-language-server

go install github.com/mattn/efm-langserver@latest

nvim --headless -c "CocInstall coc-eslint" -c "qa" || :
nvim --headless -c "CocInstall coc-tsserver" -c "qa" || :

if [ -w /go/tmp ]; then
	nvim --headless -c "GoInstallBinaries" -c "qa" || :
fi
