#!/bin/bash -ex

# ulimit 限制 http://serverfault.com/a/815837/183566

LIMIT=102400

SERVICE_FILE='/lib/systemd/system/mysql.service'

if [ -f $SERVICE_FILE ]; then
	GREP=$(grep -m 1 LimitNOFILE "$SERVICE_FILE")
	echo "$GREP"
	if [ -z "$GREP" ]; then
		sudo sed -i "s/\[Service\]\$/[Service]\nLimitNOFILE=${LIMIT}/g" $SERVICE_FILE
	else
		sudo sed -i "s/^LimitNOFILE.*\$/LimitNOFILE=${LIMIT}/g" $SERVICE_FILE
	fi

	sudo systemctl daemon-reload
	sudo systemctl restart mysql.service
fi

grep files "/proc/$(pgrep mysql)/limits"
