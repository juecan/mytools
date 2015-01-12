## SQLite

	SQLite 自包含，没有服务器，零配置，支持事务
	SQLite 的数据库就一个文件，包括：多表、索引、触发器、和视图
	SQLite 直接读写磁盘上的文件

	事务的四个特性（ACID）atomic（原子的）、consistent（一致的）、isolated（独立的）、durable（持久的） 

	SQLite 不支持并发，不是两个进程同时访问，独占式的
	代码质量高，99% 的代码都经过测试
	自包含的意思，就是不依赖外界的任何库
	sqlite3 只是一个壳，真正执行，还是会调用 SQLite 的库
	
### sqlite3 工具的功能： 
	创建数据库； 
	执行SQL命令； 
	查询数据库的表结构，或其它对象的结构； 
	导入和导出数据； 
	改变输出格式； 
	使用在shell脚本中；学会shell自动化脚本编程；
	创建数据库； 
	sqlite3 数据库文件名
	输入SQL语句的时候，结束一定要用分号，这也是SQL的标准；

### 系统表 SQLITE_MASTER

	系统表 SQLITE_MASTER，存放 database schema 
	不能对 SQLITE_MASTER 表进行 DROP TABLE,UPDATE,INSERT,DELETE 操作
	临时表存储在 sqlite_temp_master 中。 
		
### sqlite3 本身的命令 

	sqlite3 本身的命令以“.”开始，.help；
	SQL PLUS 有三大类命令： 
		SQL 命令，提交给数据库引擎； 
		PL SQL 命令，提交给数据库引擎； 
		SQL PLUS 本身的命令，本地执行；

	.help 帮助信息

	改变输出格式的命令； 
		csv，以逗号分隔的记录； 
	.mode 命令在8种显示格式中进行切换； 
		默认是 list 模式，默认的分隔线是“|”； 
			list 模式特别适合用于 AWK； 
		line 模式，每列都单独一行，列名等于列值，记录之间有空行； 
		column 模式，与 SQL PLUS 中的缺省模式相同；
			.header on 打开头
			.header off 关闭头，此模式可读性比较好； 
			.width 3 30,第一列最长3，第二列最长30； 
		insert模式，产生INSERT的SQL语句，挺有意思；
			.mode insert 目标表名； 
		html模式，XHTML table,适合做CGI处理;
		list模式一行一条记录，每列竖线分隔；

	默认查询结果是写到屏幕上，也可以写到一个文件中。使用.output命令； 
		.output stdout	输出又回到了屏幕上
		
	查询Database Schema，就是表结构、数据库结构； 
	.tables		可以看数据库中的所有表； 
	.indices	可以列出一个指定表的所有索引； 
	.schema		创建表和索引时候的create语句，也可以在后面指明表名； 
	.databases	查看当前打开的所有数据库，通常是一个main一个temp；
	
	.timeout	默认超时时间是0，查询一张表或索引，发现表或索引被锁定，就立刻返回，不等待；
		
	.explain：查询一条SQL语句最终解析出来的执行计划。ORACLE中也有，对SQL语句调优很有用； 
		一条SQL语句的处理过程：解析、分析、执行，看看SQL语句的效率； 
		> .explain 
		> explain select * from t;
	
### SQLite 命令

	启动 sqlite：
		[sqlite]# sqlite3 test.db
		
	建立自己的表：
		sqlite> create table test (id integer primary key, value text);
		
	往表中插入数据：
		sqlite> insert into test(value) values('eenie');
		sqlite> insert into test(value) values('meenie');
		sqlite> insert into test(value) values('miny');
		sqlite> insert into test(value) values('mo');
		
	设置输出格式：
		sqlite> .mode col
		sqlite> .headers on
		
	检索信息：
		sqlite> select * from test;
		id          value     
		----------  ----------
		1           eenie     
		2           meenie    
		3           miny      
		4           mo
		
	为数据库创建一个索引和一个视图：
		sqlite> create index test_idx on test(value);
		sqlite> create view schema as select * from sqlite_master;
		
	退出 sqlite：
		sqlite> .exit
		
	获取所有表和视图的列表：
		sqlite> .tables
		schema  test
		
	查看表的索引：
		sqlite> .indices test
		test_idx
		
	获取表和视图的定义语句：
		sqlite> .schema test
		CREATE TABLE test (id integer primary key, value text);
		CREATE INDEX test_idx on test(value);
		
	数据导出：
		sqlite> .output file.sql
		sqlite> .dump 不加参数导出所有数据库
		sqlite> .output stdout
		
	查询当前的数据库 sqlite_master 表：
		sqlite> .mode col
		sqlite> .headers on
		sqlite> select type, name, tbl_name, sql from sqlite_master order by type;
		type        name        tbl_name    sql                                 
		----------  ----------  ----------  ------------------------------------
		index       test_idx    test        CREATE INDEX test_idx on test(value)
		table       test        test        CREATE TABLE test (id integer primar
		view        schema      schema      CREATE VIEW schema as select * from
		
	数据导入：
		sqlite> .show
			 echo: off
		  explain: off
		  headers: off
			 mode: list
		nullvalue: ""
		   output: stdout
		separator: "|"
			width: 
		sqlite> drop table test;导入由 .dump 命令创建的文件
		sqlite> drop view schema; 先移除已经存在的数据库对象
		sqlite> .read file.sql
		
	打开回显：输入命令后命令还会显示出来
		sqlite> .echo on
		
	空串以字符显示：
		sqlite> .nullvalue NULL
		
	设置命令提示符：
		sqlite3>.prompt 'sqlite3> '
		
	设置输出格式：csv、column、html、insert、line、list（默认）、tabs、tcl
		sqlite3> .mode list
		
	备份：
		[sqlite]# sqlite3 test.db .dump > test.sql
		或
		sqlite> .output file.sql
		sqlite> .dump
		sqlite> .exit
		或
		[sqlite]# echo ".dump" | sqlite3 ex1 | gzip -c > ex1dmp.gz 
		
	导入备份：
		[sqlite]# sqlite3 test.db < test.sql
		
	得到二进制的数据库文件拷贝：
		[sqlite]# sqlite3 test.db VACUUM 释放数据库文件中未使用的空间
		[sqlite]# cp test.db test.backup
		
	将 sql 语句写入文件，从外部创建表
		[test]# vim create_exam.sql 
		create table exam
		(
				id integer primary key,
				value text
		);
		[test]# sqlite3 exam.db < create_exam.sql
		
	删除表中数据：
		sqlite> delete from exam where id=1;

	重构数据库的命令
		zcat ex1dmp.gz | sqlite3 ex2 
		从SQLite3中提取数据，导到其它流行的数据库中；

	在SHELL中使用SQLite3的命令； 
		# sqlite3 demo.db "select * from t"
