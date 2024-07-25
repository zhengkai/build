#!/bin/bash

# neovim 配置完成后需要安装的第三方软件

# :CocInstall coc-tsserver

npm i -g bash-language-server

go install github.com/mattn/efm-langserver@latest

:CocInstall coc-eslint
:CocInstall coc-tsserver
