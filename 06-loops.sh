#!/bin/bash

echo "==================================="
echo "        BASH LOOP PRACTICE"
echo "==================================="

echo
echo "FOR LOOP - DevOps Tools"

for tool in Git Maven Jenkins Docker Kubernetes
do
    echo "Checking tool: $tool"
done

echo
echo "WHILE LOOP - Countdown"

count=5

while [ "$count" -gt 0 ]
do
    echo "Starting in: $count"
    count=$((count - 1))
done

echo "Starting DevOps process..."

echo "==================================="
