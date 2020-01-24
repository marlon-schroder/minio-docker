#!/bin/sh

if [ -z $2 ]; then
	echo "Use: $0 [user] [passwd]"
	exit 0
fi

USER="$1"
PASSWD="$2"
MC="$HOME/.bin/mc"
JSON="$HOME/minio_docker/user.json"

#################################
## CREATE JSON POLICY FOR USER ##
#################################
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
			"Resource": ["arn:aws:s3:::${USER}/*"]
		}
	]
}
EOF

user_exist=$($MC admin user list server|grep $USER|awk '{print $2}')
if [ "$user_exist" = "$USER" ]; then
	echo "User $USER already exist!"
	exit 1
fi

#################
## TO ADD USER ##
#################
# add policy 'user' as file '$JSON'
$MC admin policy add server $USER $JSON
# add user '$USER' in 'server' with passwd '$PASSWD'
$MC admin user add server $USER $PASSWD
# add policy 'user' for user '$USER'
$MC admin policy set server $USER user=$USER
# create principal bucket for $USER
$MC mb server/$USER

####################
## TO REMOVE USER ##
####################
# remove policy 'user'
#$MC admin policy remove server $USER
# remove user '$USER'
#$MC admin user remove server $USER

############
## OTHERS ##
############
# list policies in 'server'
#$MC admin policy list server
# show policy
#$MC admin policy info server user
# remove ALL buckets!
#$MC rb --force --dangerous server

rm -rf $JSON
