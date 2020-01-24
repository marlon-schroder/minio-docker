#!/bin/sh

MC="$HOME/.bin/mc"

echo ""
echo "###############"
echo "#### Users ####"
echo "###############"
#$MC admin user list server

for users in $($MC admin user list server|awk '{print $2}'); do
	$MC admin user info server $users
	echo ""
done

echo "#################"
echo "#### Groups #####"
echo "#################"
for groups in $($MC admin group list server); do
	$MC admin group info server $groups
	echo ""
done

echo "##################"
echo "#### Policies ####"
echo "##################"
$MC admin policy list server|grep -v 'read\|write'

echo ""

# Users of GROUP
#users_group=$($MC admin group info server $GROUP|grep 'Members:'|awk '{print $2}'|sed -e 's/,/ /g')
