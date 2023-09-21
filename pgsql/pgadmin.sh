#!/bin/bash

curl -s https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add -

echo "deb [arch=amd64] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin.list

sudo apt update
