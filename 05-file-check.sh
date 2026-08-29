#!/bin/bash

CONFIG_FILE="03-conditions.sh"
BACKUP_DIR="backup"

echo "==================================="
echo "       FILE SYSTEM CHECK"
echo "==================================="

if [ -f "$CONFIG_FILE" ]; then
    echo "Config File : $CONFIG_FILE exists"
else
    echo "Config File : $CONFIG_FILE missing"
fi

if [ -d "$BACKUP_DIR" ]; then
    echo "Backup Dir  : $BACKUP_DIR exists"
else
    echo "Backup Dir  : $BACKUP_DIR missing"
fi

echo "==================================="
