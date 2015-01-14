## fern-wifi-cracker

### 安装

	sudo apt-get install reaver macchanger aircrack-ng xterm subversion python python-qt4 python-scapy
	32 位系统：sudo apt-get install ia32-libs
	下载：https://www.fern-pro.com/download.php Fern Open Source
	sudo dpkg -i Fern_Open_Source*.deb
	sudo apt-get install -f
	
	root@kali:~# cat /usr/bin/fern-wifi-cracker 
	#!/bin/bash
	cd /usr/share/fern-wifi-cracker/ && python execute.py "$@"
