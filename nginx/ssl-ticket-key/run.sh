#!/bin/bash

# 21	13	* * * ~/build/nginx/ssl-ticket-key/run.sh >/dev/null 2>&1

FILE="/etc/nginx/ssl.d/session-ticket-current.key"
PREV="/etc/nginx/ssl.d/session-ticket-prev.key"

if [ -e "$FILE" ]; then
	CHECK=$(find "$PREV" -type f -mmin +30)
	if [ -z "$CHECK" ]; then
		exit
	fi
	sudo mv "$FILE" "$PREV"
else
	openssl rand 80 | sudo tee "$PREV" >/dev/null
fi

openssl rand 80 | sudo tee "$FILE" >/dev/null

sudo service nginx force-reload
