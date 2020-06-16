#! /bin/bash -ex

DIR=$(readlink -f "$0") && DIR=$(dirname "$DIR") && cd "$DIR" || exit 1

MY_CNF="${HOME}/.my.cnf"
if [ -e "$MY_CNF" ]; then
	>&2 echo "$MY_CNF installed"
	exit 1
fi

CHECK_INSTALL=$(sudo dpkg -s mysql-server 2>/dev/null || :)
if [ -n "$CHECK_INSTALL" ]; then
	>&2 echo 'mysql-server installed'
	exit 1
fi

CODENAME=$(lsb_release -c -s)

ARCH=$(arch)
if [ "$ARCH" == 'x86_64' ]; then
	ARCH='amd64'
elif [ "$ARCH" == 'aarch64' ]; then
	ARCH='arm64'
else
	>&2 echo unknown arch $ARCH
	exit
fi

sudo apt install -y pwgen debconf-utils

# https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-repo-manual-setup
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5072E1F5

PASSWORD=$(pwgen -cns 15)

sed "s/^password=\$/password=${PASSWORD}/g" ./templet.cnf > "$MY_CNF"
chmod 600 "$MY_CNF"

#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
#sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password $PASSWORD"
#sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password $PASSWORD"
#sudo debconf-set-selections <<< "mysql-community-server mysql-server/default-auth-override select Use Strong Password Encryption (RECOMMENDED)"

# https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-repo-manual-setup

#sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5

gpg --import mysql-pubkey.asc
sudo apt-key add mysql-pubkey.asc

SOURCE='source.list'
echo "deb [arch=${ARCH}] http://repo.mysql.com/apt/ubuntu/ ${CODENAME} mysql-8.0" | tee "$SOURCE"
sudo cp "$SOURCE" /etc/apt/sources.list.d/mysql.list

sudo apt update

sudo apt install -y mysql-community-client mysql-community-server

# sudo apt install libmysqlclient-dev
