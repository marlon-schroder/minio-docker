#!/bin/sh

IP="127.0.0.1"
bucket="marlon"

echo "marlon:papa0101" > $HOME/.passwd-s3fs
chmod 600 ${HOME}/.passwd-s3fs
[ ! -d $HOME/remoto ] && mkdir $HOME/remoto
s3fs $bucket $HOME/remoto -o allow_other,use_path_request_style,nonempty,url=http://${IP}:9000,passwd_file=${HOME}/.passwd-s3fs
