## ubuntu 安装 kali 工具

### driftnet

	(driftnet:8606): Gtk-WARNING **: 无法在模块路径中找到主题引擎：“pixmap”

### 

dumpcap需要root权限才能使用的,以普通用户打开Wireshark，Wireshark当然没有权限使用dumpcap进行截取封包。

解决这个问题的办法——可以使用用户组功能使用Wireshark，具体操作： 
 
1、添加wireshark用户组 
 
sudo groupadd wireshark 
 
2、将dumpcap更改为wireshark用户组 
 
sudo chgrp wireshark /usr/bin/dumpcap 
 
3、让wireshark用户组有root权限使用dumpcap 
 
sudo chmod 4755 /usr/bin/dumpcap 
 
(注意:如果设为4754 Wireshark还是会提示没有权限 ) 
	 
	4、将需要使用的普通用户名加入wireshark用户组，我的用户是“dengyi”（需要根据具体用户名修改！），则需要使用命令： 
	 
	sudo gpasswd -a dengyi wireshark 
	 
	这样就完成了，以普通用户dengyi登陆打开Wireshark就会有权限进行抓包了。
