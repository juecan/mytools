## linux 开机启动
	
### CentOS7

	设置 SSH 开机启动
		systemctl enable ssh
	
	取消 SSH 开机启动
		systemctl disabled ssh

### Kali

	设置 SSH 开机启动
		update-rc.d ssh enable
		
	取消 SSH 开机启动
		update-rc.d ssh disabled
