#!/bin/bash

echo "========================================"
echo " SYSTEM INFORMATION"
echo "========================================"

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
FQDN=$(hostname -f)
DNS=$(grep nameserver /etc/resolv.conf | awk 'NR==1 {print $2}')
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

echo "Hostname       : $HOSTNAME"
echo "Primary IP     : $IP"
echo "FQDN           : $FQDN"
echo "DNS Server     : $DNS"
echo "Gateway        : $GATEWAY"
