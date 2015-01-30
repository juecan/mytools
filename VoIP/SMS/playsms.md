# playsms 使用 HTTP 接口连接 OpenVox GSM Gateway

## 安装 PlaySMS

	推荐使用 CentOS6.x

	1. 安装依赖：
		apache or nginx or lighttpd
		mysql >= 5
		php >= 5.3, php-mysql, php-cli, php-mbstring, php-gd, php-pear and pear install db
		gettext

	2. 更改 mysql root 密码
		[~]# mysql
		mysql> set password=password('111111');
		mysql> flush privileges;
		mysql> quit

	3. 解压 playsms 源码

	4. 拷贝 install.conf.dist 为 install.conf，并修改其中：
		DBPASS 为 mysql 密码
		WEBSERVERUSER="apache"(/etc/httpd/conf/httpd.conf: User apache)
		WEBSERVERUSER="apache"(/etc/httpd/conf/httpd.conf: Group apache)

	5. playsmsd start

	6. 浏览器登陆：YourServerIP/playsms
		username: admin
		password: admin
	
## 发送短信

	1. Settings - Manage gateway and SMSC - openvox - add（注意，不是 edit 按钮）
		SMSC name: openvox
		Gateway host: 172.16.179.1
		Gateway port: 80
		Username: admin
		Password: admin
		配置参考：OpenVox GSM Gateway - SMS - SMS Settings - HTTP to SMS

	2. Settings - Route outgoing SMS - Add route
		User: Administrator
		Destination name: openvox out
		Prefix: 6
		SMSC: openvox
		注：Prefix 为号码前缀，如发送至号码为 66375，实际号码为 66375

	3. My account - Send message
		Send to: 66375
		Message: test

	4. My account - Outgoing messages
		黄色小圆点：正在发送
		绿色小圆点：已发送
		红色小圆点：发送失败
		
	注：分段发送长短信
	
## 接收短信

	1. Settings - Route incoming SMS
		Route all sandbox SMS to users: Administrator
		Other: no

	2. chmod 777 /var/www/html/playsms/plugin/gateway/openvox/callback.php(原始权限为 644)

	3. 更改 OpenVox GSM Gateway - SMS - SMS Settings - SMS to HTTP 配置
		URL: http://YourPlaySMS:80/playsms/plugin/gateway/openvox/callback.php?phonenumber=phonenumber&port=port&message=message
	
	注：分段接收长短信
	