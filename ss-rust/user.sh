#!/bin/bash

NAME="shadowsocks"

sudo adduser \
	--no-create-home \
	--disabled-login \
	--disabled-password \
	--comment "" \
	--shell /usr/sbin/nologin \
	--home /nonexistent \
	"$NAME"
