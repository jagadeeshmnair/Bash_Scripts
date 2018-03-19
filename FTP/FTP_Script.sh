#!/bin/bash

IP=192.168.114.134
HOSTNAME=server13.localdomain

echo "$IP $HOSTNAME" >> /etc/hosts

#install ftp files

yum -y install vsftpd ftp

#create a backup of vsftpd.conf file

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf_backup

sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf
sed -i 's/#local_enable=YES/local_enable=YES/g' /etc/vsftpd/vsftpd.conf
sed -i 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd/vsftpd.conf

#To enable ftp to all users in this server

sed -i 's/chroot_local_user=NO/chroot_local_user=YES/g' /etc/vsftpd/vsftpd.conf


sed -i 's/root/#root/g' /etc/vsftpd/ftpusers
sed -i 's/root/#root/g' /etc/vsftpd/user_list

#echo "-A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT" >> /etc/sysconfig/iptables-config (if using Iptables)

systemctl restart vsftpd.service
systemctl enable vsftpd.service

firewall-cmd --add-service=ftp --permanent
firewall-cmd --reload

chkconfig vsftpd on

echo "Login to FTP with your root account"

#logging to FTP with root account credentials

ftp $HOSTNAME


