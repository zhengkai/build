#! /bin/bash -e

cd `dirname "${BASH_SOURCE[0]}"`

if [ -e ~/.my.cnf ]; then
	>&2 echo '~/.my.cnf installed'
	exit 1
fi

if [ -n "`sudo dpkg -s mysql-server 2>/dev/null`" ]; then
	>&2 echo 'mysql-server installed'
	exit 1
fi

sudo apt-get -y install pwgen debconf-utils

PASSWORD=`pwgen -cns 12`

# echo $PASSWORD

sed 's/^password=$/password='$PASSWORD'/g' ./templet.cnf > ~/.my.cnf
chmod 600 ~/.my.cnf

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password '$PASSWORD
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '$PASSWORD
sudo apt-get -y install mysql-server
