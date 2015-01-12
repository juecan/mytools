Q: CentOS7 设置 httpd 使用 IP 访问，需要开启防火墙
A: iptables -I INPUT -p TCP --dport 80 -j ACCEPT

Q: Ubuntu 启动 apache2, No such file or directory: AH02291: Cannot access directory '/var/log/apache2/' for main error log
A: mkdir -p /var/log/apache2/
A: /etc/init.d/apache2 start