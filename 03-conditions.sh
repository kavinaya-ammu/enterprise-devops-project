#!/bin/bash

NAME="Charles"
ENVIRONMENT="production"

echo "==================================="
echo "==================================="
echo "Name        : $NAME"
echo "Environment : $ENVIRONMENT"
echo "==================================="
echo "==================================="

if [ "$ENVIRONMENT" = "development" ]; then
    echo "Environment check : DEVELOPMENT"
elif [ "$ENVIRONMENT" = "Testing" ]; then
    echo "Environment check : QA TESTING"
elif [ "$ENVIRONMENT" = "production" ]; then
    echo "Environment check : PRODUCTION"
else
    echo "Environment check : UNKNOWN"
fi
