#! /bin/bash -ex

DIR="$(dirname "$(readlink -f "$0")")" && cd "$DIR" || exit 1

GPG_FILE="/usr/share/keyrings/mysql.gpg"
sudo cp mysql.gpg "$GPG_FILE"
sudo chmod 644 "$GPG_FILE"

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

PASSWORD=$(pwgen -cns 15)

sed "s/^password=\$/password=${PASSWORD}/g" ./templet.cnf > "$MY_CNF"
chmod 600 "$MY_CNF"

PACKAGE="mysql-community-server"

# sudo debconf-show mysql-community-server
sudo debconf-set-selections <<< "${PACKAGE} ${PACKAGE}/root-pass password $PASSWORD"
sudo debconf-set-selections <<< "${PACKAGE} ${PACKAGE}/re-root-pass password $PASSWORD"
sudo debconf-set-selections <<< "${PACKAGE} mysql-server/default-auth-override select Use Strong Password Encryption (RECOMMENDED)"

SOURCE='source.list'
echo "deb [arch=${ARCH} signed-by=${GPG_FILE}] http://repo.mysql.com/apt/ubuntu/ ${CODENAME} mysql-8.0" | tee "$SOURCE"
sudo cp "$SOURCE" /etc/apt/sources.list.d/mysql.list

sudo apt update

sudo apt install -y mysql-community-client "$PACKAGE"
