## 设置 mysql 默认 root 密码

	[~]# mysql
	Welcome to the MySQL monitor.  Commands end with ; or \g.
	Your MySQL connection id is 2
	Server version: 5.1.73 Source distribution

	Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

	Oracle is a registered trademark of Oracle Corporation and/or its
	affiliates. Other names may be trademarks of their respective owners.

	Type 'help;' or '\h' for help. Type '\c' to clear the current input statement

	mysql> set password=password('111111');
	Query OK, 0 rows affected (0.00 sec)

	mysql> flush privileges;
	Query OK, 0 rows affected (0.00 sec)

	mysql> quit
	Bye