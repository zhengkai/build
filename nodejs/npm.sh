#!/bin/sh -ex
for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
do
	sudo npm -g install "$package"
done
