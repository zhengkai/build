#!/bin/bash
sudo iptables -A OUTPUT ! -o eth0 -m owner --uid-owner shadowsocks \
    -j REJECT --reject-with icmp-host-prohibited

cd "$( dirname "${BASH_SOURCE[0]}" )"
sudo -u shadowsocks ./server.sh
