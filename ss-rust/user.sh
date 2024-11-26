#!/bin/bash

NAME="shadowsocks"

sudo adduser -M \
	--disabled-login \
	--disabled-password \
	--comment "" \
	-s /usr/sbin/nologin \
	-d /nonexistent \
	"$NAME"
