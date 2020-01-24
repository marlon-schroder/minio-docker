#!/bin/sh

if [ -z $1 ]; then
	echo "Use: $0 [user]"
	exit 0
fi

USER="$1"
MC="$HOME/.bin/mc"

user_exist=$($MC admin user list server|grep $USER|awk '{print $2}')
if [ "$user_exist" != "$USER" ]; then
	echo "User $USER not exist!"
	exit 1
fi

####################
## TO REMOVE USER ##
####################
# remove policy 'user'
$MC admin policy remove server $USER
# remove user '$USER'
$MC admin user remove server $USER

$MC rb --force server/$USER
