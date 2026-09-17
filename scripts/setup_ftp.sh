#!/bin/bash
which vsftpd >/dev/null 2>&1 || { apt update || true; apt install -y vsftpd ftp; }

# buat user + password
id alice >/dev/null 2>&1 || useradd -m alice
id mika  >/dev/null 2>&1 || useradd -m mika
id eiri  >/dev/null 2>&1 || useradd -m eiri
echo "alice:alice123" | chpasswd
echo "mika:mika123"   | chpasswd
echo "eiri:eiri123"   | chpasswd

# folder share
mkdir -p /var/wired/data
chown alice:alice /var/wired/data
chmod 755 /var/wired/data

# override read-only khusus mika
mkdir -p /etc/vsftpd/user_conf
echo "write_enable=NO" > /etc/vsftpd/user_conf/mika

# blacklist eiri
echo "eiri" > /etc/vsftpd/user_list

# konfigurasi utama vsftpd
cat > /etc/vsftpd.conf <<'CFG'
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
chroot_local_user=YES
allow_writeable_chroot=YES
local_root=/var/wired/data
user_config_dir=/etc/vsftpd/user_conf
userlist_enable=YES
userlist_file=/etc/vsftpd/user_list
userlist_deny=YES
seccomp_sandbox=NO
pam_service_name=vsftpd
CFG

service vsftpd restart
echo "[*] FTP ready"