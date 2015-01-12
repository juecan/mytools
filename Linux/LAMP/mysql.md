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

### 无法连接到 MySQL

	Q：ERROR 2002 (HY000) Can't connect to local MySQL server through socket 'varlibmysqlmysql.sock' (2)
	A：service mysqld start

### MySQL 相关命令

	查看已经存在的数据库：
		mysql> show databases
		或
		[~]# mysqlshow

	查看时间，用户，版本：
		mysql> select now(), user(), version();

	使用 mysql 数据库：
		mysql> use mysql
	
	查看 mysql 数据库下面的表：
		mysql> show tables;
		或
		[~]# mysqlshow along_database

	建立自己的数据库：
		mysql> create database along_database;
	
	使用自己的数据库：
		mysql> use along_database
	
	建立自己的表：
		mysql> create table president
			-> (
			-> last_name varchar(15) not null,
			-> first_name varchar(15) not null,
			-> suffix varchar(15) null,
			-> city varchar(20) not null,
			-> state varchar(2) not null,
			-> birth date not null,
			-> death date null 
			-> );
		[mysql]# vim create_member.sql
		create table member
		(
				lase_name varchar(20) not null,
				first_name varchar(20) not null,
				suffix_name varchar(5) null,
				expiration date null default "0000-00-00",
				email varchar(100) null,
				street varchar(50) null,
				city varchar(50) null,
				state varchar(2) null,
				zip varchar(10) null,
				phone varchar(20) null,
				interrests varchar(255) null
		)
		[mysql]# mysql along_database < create_member.sql
		
	查看表信息：
		mysql> describe president;
		或
		[~]# mysqlshow along_database member
		
	往表中插入数据：
		mysql> insert into student values('Kyle', 'M', null);
		mysql> insert into student values('Mary', 'M', null), ('Abby', 'F', null);
		mysql> insert into member (lase_name, first_name) values('Stein', 'Waldo');
		mysql> insert into student (name, sex) values('Mike', 'F'), ('Kang', 'M');
		mysql> insert into member set lase_name='Jane', first_name='Ai';
		mysql> load data local infile "/tmp/member.txt" into table member;
		[~]# mysqlimport --local along_database /tmp/member.txt
		
	检索信息：
		mysql> select * from member;
		mysql> select * from student where sex='F';
		mysql> select 2+2, "Hello, World", version();
		mysql> select name from student;
		mysql> select name, sex, student_id from student;
		mysql> select * from score where score > 95;
		mysql> select last_name, first_name from president where last_name="ROOSEVELT";
		mysql> select last_name, first_name, birth from president where birth < "1750-1-1";
		mysql> select last_name, first_name, birth from president where birth < "1750-1-1" and (state="VA" or state="MA");
		mysql> select last_name, first_name from president death is null;
		mysql> select last_name, first_name from president death is not null;
		mysql> select last_name, first_name, suffix from president where not (suffix <=> null);
		mysql> select last_name, first_name from president order by last_name; 升序
		mysql> select last_name, first_name from president order by last_name asc; 升序
		mysql> select last_name, first_name from president order by last_name desc; 降序
		mysql> select last_name, first_name, state from president order by state desc, last_name asc; 降序 - 升序
		mysql> select last_name, first_name, birth from president order by birth limit 5; 前五行
		mysql> select last_name, first_name, birth from president order by birth limit 10, 5; 第十一行开始的五行
		mysql> select last_name, first_name from president order by rand() limit 1; 随机抽取一行记录