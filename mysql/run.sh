#! /bin/bash -ex

cd $(dirname `readlink -f $0`)

if [ -e ~/.my.cnf ]; then
	>&2 echo '~/.my.cnf installed'
	exit 1
fi

if [ -n "`sudo dpkg -s mysql-server 2>/dev/null`" ]; then
	>&2 echo 'mysql-server installed'
	exit 1
fi

sudo apt install -y pwgen debconf-utils

# https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-repo-manual-setup
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5072E1F5

PASSWORD=`pwgen -cns 12`

sed 's/^password=$/password='$PASSWORD'/g' ./templet.cnf > ~/.my.cnf
chmod 600 ~/.my.cnf

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"

# https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-repo-manual-setup

#sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5

gpg --import mysql-pubkey.asc
sudo apt-key add mysql-pubkey.asc

LIST_FILE='/etc/apt/sources.list.d/mysql.list'
if [ ! -e "$LIST_FILE" ]; then
	sudo cp source.list "$LIST_FILE"
fi
sudo apt update

sudo apt install -y mysql-server

# sudo apt install libmysqlclient-dev
