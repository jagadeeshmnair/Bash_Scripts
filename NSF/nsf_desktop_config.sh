#Script to configure nsf machine

#!/bin/bash

#Create a directory to mount the nsf share to client machine.

mkdir /mnt/nsf

echo "server.localdomain:/nfsshare /mnt/nfs nfs defaults 0 0" >> /etc/fstab

mount -a

df -h