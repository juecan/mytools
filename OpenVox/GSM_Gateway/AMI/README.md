## OpenVox Gateway AMI 介绍

	Asterisk Manager Interface

### 启用 AMI 接口

	Gateway - ADVANCED - Asterisk API - General - Enable: ON
	
### WEB 配置 AMI 接口

	Manager Name: 登陆的用户名
	Manager secret: 登陆的密码
	Deny: 不允许登陆的 IP 地址和子网掩码
	Permit: 允许链接的 IP 地址和子网掩码

	Manager Name: admin
	Manager secret: admin
	Deny: 0.0.0.0/0.0.0.0
	Permit: 172.16.8.180/255.255.0.0
	注：只允许 172.16.8.180 以 admin/admin 访问 AMI
	
### 后台配置 AMI 接口

	/etc/asterisk/manager.conf:
		[general]
		bindaddr=0.0.0.0
		enabled=yes
		port=5038
		[admin]
		secret=admin
		permit=0.0.0.0/255.255.0.0
		read=system,call,log,verbose,agent,user,config,dtmf,reporting,cdr,dialplan
		write=system,call,log,verbose,command,agent,user,config,reporting,originate
		
### telnet 访问 AMI 接口

	telnet [user@]host [port]
	
	telnet 172.16.8.186 5038
	
### 使用脚本访问 AMI 接口

	子目录 c：使用 C 语言访问 AMI 接口
	子目录 php：使用 php 脚本访问 AMI 接口