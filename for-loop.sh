#!/bin/bash

echo "=============================="
echo " DEVOPS SERVER INVENTORY"
echo "=============================="

servers=(
    "amazondev-server01"
    "192.1.2.50"
    "amazontest-server02"
    "192.1.2.51"
    "amazonuat-server03"
    "192.1.2.52"
)

for server in "${servers[@]}"
do
    echo "Checking server: $server"
done
