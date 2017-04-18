#!/bin/bash -x

echo 'config file = '$CONFIG_FILE
echo '   pid file = '$PID_FILE

ulimit -n 51200
/usr/local/bin/ss-local \
	--fast-open \
	--mptcp \
	-c $CONFIG_FILE \
	-f $PID_FILE

echo 'pid = '`cat $PID_FILE`
