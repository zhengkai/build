#!/usr/bin/env bash

PGP_FILE="/etc/apt/keyrings/packages-pgadmin-org.gpg"

curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o "$PGP_FILE"
echo "deb [signed-by=${PGP_FILE}] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin.list

sudo apt update

sudo apt install pgadmin4-web
