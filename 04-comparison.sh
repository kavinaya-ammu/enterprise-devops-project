#!/bin/bash

CPU_USAGE=75
DISK_USAGE=82

echo "==================================="
echo "       SYSTEM HEALTH CHECK"
echo "==================================="

echo "CPU Usage  : ${CPU_USAGE}%"
echo "Disk Usage : ${DISK_USAGE}%"

if [ "$CPU_USAGE" -gt 80 ]; then
    echo "CPU Status  : HIGH"
else
    echo "CPU Status  : NORMAL"
fi

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "Disk Status : HIGH"
else
    echo "Disk Status : NORMAL"
fi

echo "==================================="
