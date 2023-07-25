#!/bin/bash

# Wait for Docker to start
sleep 60

declare -a dirs=("/root/.shardeum0"
                 "/root/.shardeum1"
                 "/root/.shardeum2"
                 "/root/.shardeum3"
                 "/root/.shardeum4"
                 "/root/.shardeum5"
                 "/root/.shardeum6"
                 "/root/.shardeum7"
                 "/root/.shardeum8"
                 "/root/.shardeum9")

for dir in "${dirs[@]}"
do
  cd $dir >> /root/startup.log 2>&1
  ./docker-up.sh >> /root/startup.log 2>&1
done
