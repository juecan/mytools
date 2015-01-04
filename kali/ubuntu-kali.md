## ubuntu 安装 kali 工具

### driftnet

	(driftnet:8606): Gtk-WARNING **: 无法在模块路径中找到主题引擎：“pixmap”

### 普通用户使用 Wireshark

	1、添加 wireshark 用户组：sudo groupadd wireshark 
	2、将 dumpcap 更改为 wireshark 用户组：sudo chgrp wireshark /usr/bin/dumpcap
	3、让 wireshark 用户组有 root 权限使用 dumpcap：sudo chmod 4755 /usr/bin/dumpcap 
	4、将需要使用的普通用户名加入 wireshark 用户组，我的用户是“dengyi”：sudo gpasswd -a dengyi wireshark 
