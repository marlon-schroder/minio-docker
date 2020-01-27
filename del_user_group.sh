#!/bin/sh

if [ -z $2 ]; then
	echo "Use: $0 [group] [user]"
	exit 0
fi

GROUP="$1"
USER="$2"
MC="$HOME/.bin/mc"
JSON="$HOME/minio-docker/group.json"

if [ ! -z $USER ]; then
	user_exist=$($MC admin user list server|grep $USER|awk '{print $2}')
	if [ "$user_exist" != "$USER" ]; then
		echo "User $USER not exist!"
		exit 1
	fi
fi

if [ ! -z $GROUP ]; then
	group_exist=$($MC admin group list server|grep $GROUP)
	if [ "$group_exist" != "$GROUP" ]; then
		echo "Group $GROUP not exist!"
		exit 1
	fi
fi

# Remove USER from GROUP
$MC admin group remove server $GROUP $USER

# Remove bucket of GROUP
#$MC rb $GROUP
