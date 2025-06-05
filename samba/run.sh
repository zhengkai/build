#!/bin/bash

sudo apt install -y samba

sudo sed -i "s#map to guest = bad user#map to guest = never#" /etc/samba/smb.conf
