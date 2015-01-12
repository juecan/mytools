#!/bin/bash

# Add a IP address
ifconfig enp4s2:0 192.168.2.222 netmask 255.255.255.0
sleep 60
# mount Windows Share Folder
# yum install cifs-utils
# git uid: 1001, root gid: 0
# Windows Share folder: //192.168.2.5/backup/OpenVoxGitServer, username=administrator, password=OpenVoxBackupserver
mount.cifs -o rw,uid=1001,gid=0,username=administrator,password=OpenVoxBackupserver //192.168.2.5/backup/OpenVoxGitServer /gitlab-share
sleep 60
# Backup Gitlab
gitlab-rake gitlab:backup:create
sleep 60
# move to Windows Share Folder
mv /var/opt/gitlab/backups/* /gitlab-share/
sleep 60
# umount Windows Share Folder
umount /gitlab-share
