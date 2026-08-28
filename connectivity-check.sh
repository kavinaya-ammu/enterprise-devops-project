#!/bin/bash

echo "================================="
echo " MY LAPTOP CONNECTIVITY CHECK"
echo "================================="

servers=(
    "DESKTOP-R66B3GE"
    "172.31.71.174"
    "DESKTOP-R66B3GE.localdomain"
)

for server in "${servers[@]}"
do
    echo
    echo "Checking: $server"

    if ping -c 1 -W 2 "$server" > /dev/null 2>&1
    then
        echo "STATUS: $server is UP"
    else
        echo "STATUS: $server is DOWN"
    fi
done
