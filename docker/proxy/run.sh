#!/bin/bash

export PROXY="http://127.0.0.1:8118"
export NOPROXY="*.tuna.tsinghua.edu.cn,*.aliyuncs.com,10.0.0.0/8,127.0.0.0/8"

cd "$(dirname "$(readlink -f "$0")")" || exit 1

DAEMON_JSON="/etc/docker/daemon.json"
echo "$DAEMON_JSON"
echo
if [ -e "$DAEMON_JSON" ]; then
	envsubst < ./daemon.json
else
	envsubst < ./daemon.json | sudo tee "$DAEMON_JSON"
fi
echo

SERVICE_CONF="/etc/systemd/system/docker.service.d/http-proxy.conf"
echo "$SERVICE_CONF"
echo
if [ -e "$SERVICE_CONF" ]; then
	envsubst < ./service.conf
else
	sudo mkdir -p "$(dirname "$SERVICE_CONF")"
	envsubst < ./service.conf | sudo tee "$SERVICE_CONF"
fi
echo

ROOT_JSON="/root/.docker/config.json"
echo "$ROOT_JSON"
echo
if [ -e "$ROOT_JSON" ]; then
	envsubst < ./config.json
	echo
	echo sudo systemctl daemon-reload
	echo sudo systemctl restart docker
else
	sudo mkdir -p "$(dirname "$ROOT_JSON")"
	envsubst < ./config.json | sudo tee "$ROOT_JSON"
	sudo systemctl daemon-reload
	sudo systemctl restart docker
fi
echo

CONTAINERD_TOML="/etc/containerd/config.toml"
echo "$CONTAINERD_TOML"
echo
envsubst < ./containerd.toml
echo

set -x
sudo docker run --rm alpine sh -c 'env | grep -i  _PROXY'
