#!/bin/bash -ex

sudo apt install fail2ban firewalld

~/conf/bin/acl sudo /etc/fail2ban/jail.d
~/conf/bin/acl sudo /etc/fail2ban/filter.d
~/conf/bin/acl sudo /usr/lib/firewalld/services

sudo /usr/bin/firewall-cmd --add-service=http --permanent
sudo /usr/bin/firewall-cmd --add-service=https --permanent

cd "$(dirname "$(readlink -f "$0")")" || exit 1

cp ./filter-nginx.conf /etc/fail2ban/filter.d/nginx-sniff.conf
cp ./jail-nginx.conf /etc/fail2ban/jail.d/nginx-sniff.conf
cp ./firewalld.xml /usr/lib/firewalld/services/ss.xml

sudo /usr/bin/systemctl restart firewalld.service
sudo /usr/bin/systemctl restart fail2ban.service

sudo /usr/bin/firewall-cmd --add-service=ss --permanent

sudo /usr/bin/fail2ban-client status nginx-sniff
