#!/bin/bash

# 尽可能优雅的修改配置 sshd_config，使之禁止明文密码

if [ -n "`grep '^PasswordAuthentication no$' /etc/ssh/sshd_config`" ]; then
	echo 'no password login, good'
	exit
fi

if [ -n "`grep '^PasswordAuthentication' /etc/ssh/sshd_config`" ]; then
	sudo sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication no/g' /etc/ssh/sshd_config
	exit
fi

if [ -n "`grep '^#PasswordAuthentication' /etc/ssh/sshd_config`" ]; then
	sudo sed -i 's/^#PasswordAuthentication.*$/PasswordAuthentication no/g' /etc/ssh/sshd_config
	exit
fi

echo -e '\nPasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config

if [ -z "`grep '^PasswordAuthentication no$' /etc/ssh/sshd_config`" ]; then
	>2& echo 'no password fail'
	exit 1
fi
