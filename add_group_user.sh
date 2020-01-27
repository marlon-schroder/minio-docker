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

# Add policy to user in group
cat > $JSON << EOF
{
	"Version":"2012-10-17",
	"Statement":[
		{
			"Action": [
			"s3:CreateBucket",
			"s3:DeleteBucket",
			"s3:ListBucket",
			"s3:GetObject",
			"s3:PutObject",
			"s3:DeleteObject"
		],
		"Effect": "Allow",
		"Resource": ["arn:aws:s3:::${GROUP}/*"]
		}
	]
}
EOF

#######################
## ADD USER TO GROUP ##
#######################
$MC admin group add server $GROUP $USER

# If not bucket of GROUP, then create
bucket_exist=$($MC stat server/${GROUP}|grep Type|awk '{print $3}')
if [ "$bucket_exist" != "folder" ]; then
	# Add bucket of group
	$MC mb server/$GROUP
fi

# If policy not exist in GROUP, then add
policy_exist=$($MC admin group info server $GROUP|grep Policy|awk '{print $2}')
if [ "$policy_exist" != "$GROUP" ]; then
	# add policy 'GROUP' as file '$JSON'
	$MC admin policy add server $GROUP $JSON

	# Add policy to group
	$MC admin policy set server $GROUP group=$GROUP
fi

rm -rf $JSON
