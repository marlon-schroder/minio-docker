#!/bin/sh

#wget https://dl.min.io/client/mc/release/linux-amd64/mc
#docker pull minio/minio

docker run -p 9000:9000 -v /minio:/data minio/minio server /data &
