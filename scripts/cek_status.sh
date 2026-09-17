#!/bin/bash
echo "Ringkasan Interface"
ip -br a
echo
echo "Status Tabel NAT"
iptables -t nat -L -v -n
