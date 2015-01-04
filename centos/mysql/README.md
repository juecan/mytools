## MySQL 操作

### 设置 mysql 默认 root 密码

	[~]# mysql
	mysql> set password=password('111111');
	mysql> flush privileges;
	mysql> quit
	
### 设置远程访问 MySQL

	[~]# mysql -u root -p
	mysql> show databases;
	mysql> use mysql;
	mysql> show tables;
	mysql> select host, user from user;
	mysql> update user set host = '%' where user = 'root' and host = 'localhost';
	[~]# service mysqld restart
	
	这样可能导致无法本地登录数据库，解决办法：
		远端登录数据库，复制 user 表中的 host = '%' where user = 'root' and host = 'localhost'，将 % 改为 localhost
		[~]# service mysqld restart
