#Script file to configure NFS in server machine.



#!/bin/bash

#Install nfs packages

echo "Configuring NFS"

yum -y install nfs-utils

#Create a directory /nfsshare and guve permission.


mkdir /nfsshare
chmod 777 /nfsshare

echo "/nfsshare *(rw,sync,no_root_squash)" >> /etc/exports

#rw - Writable permission to shared folder
#sync - All changes to the according filesystem are immediately flushed to the disk
#no_root_squash - The root on the client machine will have same level of access to the files on the server system.

systemctl restart nfs-server
systemctl enable nfs-server

systemctl start firewalld.service
systemctl enable firewalld.service

#add nfs to firewall service

firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload

exportfs -r
