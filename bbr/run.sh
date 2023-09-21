#!/bin/bash

cd $(dirname `readlink -f $0`)

echo kernel: `sudo uname -r`

ERR=`sudo modprobe tcp_bbr 2>&1`
if [ -n "$ERR" ]; then
	>&2 echo 'no tcp_bbr'
	exit 1
fi

MOD_CONF='/etc/modules-load.d/modules.conf'
GREP=`grep 'tcp_bbr' "$MOD_CONF"`
if [ "$GREP" != 'tcp_bbr' ]; then
	echo 'tcp_bbr' | sudo tee -a "$MOD_CONF"
	echo add tcp_bbr to "$MOD_CONF"
fi

SYS_CONF='/etc/sysctl.d/20-bbr.conf'
if [ ! -f "$SYS_CONF" ]; then
	sudo cp 20-bbr.conf "$SYS_CONF"
	echo add 20-bbr.conf to "$SYS_CONF"
fi

sudo sysctl net.ipv4.tcp_available_congestion_control
sudo sysctl -p "$SYS_CONF"

CHECK=`sudo sysctl net.ipv4.tcp_congestion_control | grep 'control = bbr'`
if [ -z "$CHECK" ]; then
	>&2 echo 'FAIL'
	exit 1
fi

echo OK, done
