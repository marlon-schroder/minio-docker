#!/bin/sh

if [ -z $1 ]; then
	echo "Use: $0 [group]"
	exit 0
fi

GROUP="$1"
MC="$HOME/.bin/mc"

if [ ! -z $GROUP ]; then
	group_exist=$($MC admin group list server|grep $GROUP)
	if [ "$group_exist" != "$GROUP" ]; then
		echo "Group $GROUP not exist!"
		exit 1
	fi
fi

# Users of GROUP
users_group=$($MC admin group info server $GROUP|grep 'Members:'|awk '{print $2}'|sed -e 's/,/ /g')
$MC admin group remove server $GROUP $users_group

# Remove GROUP
$MC admin group remove server $GROUP

# Remove ALL FILES from GROUP
$MC rm -r --force server/$GROUP

# Remove bucket of GROUP
$MC rb server/$GROUP

# Remove GROUP policy
$MC admin policy remove server $GROUP
