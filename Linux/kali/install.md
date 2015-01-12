## 安装系统

### VirtualBox 安装 Kali 后添加增强工具

	1. 添加更新源：参考 upgrade/README.md
	2. sudo apt-get update && apt-get install -y linux-headers-$(uname -r)
	3. VirtualBox - 设备 - 添加增强功能
	4. cp /media/cdrom0/VBoxLinuxAdditions.run /root/
	5. cd /root
	6. ./VBoxLinuxAdditions.run
	7. reboot