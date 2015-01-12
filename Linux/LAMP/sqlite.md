## SQLite

	SQLite �԰�����û�з������������ã�֧������
	SQLite �����ݿ��һ���ļ������������������������������ͼ
	SQLite ֱ�Ӷ�д�����ϵ��ļ�

	������ĸ����ԣ�ACID��atomic��ԭ�ӵģ���consistent��һ�µģ���isolated�������ģ���durable���־õģ� 

	SQLite ��֧�ֲ�����������������ͬʱ���ʣ���ռʽ��
	���������ߣ�99% �Ĵ��붼��������
	�԰�������˼�����ǲ����������κο�
	sqlite3 ֻ��һ���ǣ�����ִ�У����ǻ���� SQLite �Ŀ�
	
### sqlite3 ���ߵĹ��ܣ� 
	�������ݿ⣻ 
	ִ��SQL��� 
	��ѯ���ݿ�ı�ṹ������������Ľṹ�� 
	����͵������ݣ� 
	�ı������ʽ�� 
	ʹ����shell�ű��У�ѧ��shell�Զ����ű���̣�
	�������ݿ⣻ 
	sqlite3 ���ݿ��ļ���
	����SQL����ʱ�򣬽���һ��Ҫ�÷ֺţ���Ҳ��SQL�ı�׼��

### ϵͳ�� SQLITE_MASTER

	ϵͳ�� SQLITE_MASTER����� database schema 
	���ܶ� SQLITE_MASTER ����� DROP TABLE,UPDATE,INSERT,DELETE ����
	��ʱ��洢�� sqlite_temp_master �С� 
		
### sqlite3 ��������� 

	sqlite3 ����������ԡ�.����ʼ��.help��
	SQL PLUS ����������� 
		SQL ����ύ�����ݿ����棻 
		PL SQL ����ύ�����ݿ����棻 
		SQL PLUS ������������ִ�У�

	.help ������Ϣ

	�ı������ʽ����� 
		csv���Զ��ŷָ��ļ�¼�� 
	.mode ������8����ʾ��ʽ�н����л��� 
		Ĭ���� list ģʽ��Ĭ�ϵķָ����ǡ�|���� 
			list ģʽ�ر��ʺ����� AWK�� 
		line ģʽ��ÿ�ж�����һ�У�����������ֵ����¼֮���п��У� 
		column ģʽ���� SQL PLUS �е�ȱʡģʽ��ͬ��
			.header on ��ͷ
			.header off �ر�ͷ����ģʽ�ɶ��ԱȽϺã� 
			.width 3 30,��һ���3���ڶ����30�� 
		insertģʽ������INSERT��SQL��䣬ͦ����˼��
			.mode insert Ŀ������� 
		htmlģʽ��XHTML table,�ʺ���CGI����;
		listģʽһ��һ����¼��ÿ�����߷ָ���

	Ĭ�ϲ�ѯ�����д����Ļ�ϣ�Ҳ����д��һ���ļ��С�ʹ��.output��� 
		.output stdout	����ֻص�����Ļ��
		
	��ѯDatabase Schema�����Ǳ�ṹ�����ݿ�ṹ�� 
	.tables		���Կ����ݿ��е����б� 
	.indices	�����г�һ��ָ��������������� 
	.schema		�����������ʱ���create��䣬Ҳ�����ں���ָ�������� 
	.databases	�鿴��ǰ�򿪵��������ݿ⣬ͨ����һ��mainһ��temp��
	
	.timeout	Ĭ�ϳ�ʱʱ����0����ѯһ�ű�����������ֱ�������������������̷��أ����ȴ���
		
	.explain����ѯһ��SQL������ս���������ִ�мƻ���ORACLE��Ҳ�У���SQL�����ź����ã� 
		һ��SQL���Ĵ�����̣�������������ִ�У�����SQL����Ч�ʣ� 
		> .explain 
		> explain select * from t;
	
### SQLite ����

	���� sqlite��
		[sqlite]# sqlite3 test.db
		
	�����Լ��ı�
		sqlite> create table test (id integer primary key, value text);
		
	�����в������ݣ�
		sqlite> insert into test(value) values('eenie');
		sqlite> insert into test(value) values('meenie');
		sqlite> insert into test(value) values('miny');
		sqlite> insert into test(value) values('mo');
		
	���������ʽ��
		sqlite> .mode col
		sqlite> .headers on
		
	������Ϣ��
		sqlite> select * from test;
		id          value     
		----------  ----------
		1           eenie     
		2           meenie    
		3           miny      
		4           mo
		
	Ϊ���ݿⴴ��һ��������һ����ͼ��
		sqlite> create index test_idx on test(value);
		sqlite> create view schema as select * from sqlite_master;
		
	�˳� sqlite��
		sqlite> .exit
		
	��ȡ���б����ͼ���б�
		sqlite> .tables
		schema  test
		
	�鿴���������
		sqlite> .indices test
		test_idx
		
	��ȡ�����ͼ�Ķ�����䣺
		sqlite> .schema test
		CREATE TABLE test (id integer primary key, value text);
		CREATE INDEX test_idx on test(value);
		
	���ݵ�����
		sqlite> .output file.sql
		sqlite> .dump ���Ӳ��������������ݿ�
		sqlite> .output stdout
		
	��ѯ��ǰ�����ݿ� sqlite_master ��
		sqlite> .mode col
		sqlite> .headers on
		sqlite> select type, name, tbl_name, sql from sqlite_master order by type;
		type        name        tbl_name    sql                                 
		----------  ----------  ----------  ------------------------------------
		index       test_idx    test        CREATE INDEX test_idx on test(value)
		table       test        test        CREATE TABLE test (id integer primar
		view        schema      schema      CREATE VIEW schema as select * from
		
	���ݵ��룺
		sqlite> .show
			 echo: off
		  explain: off
		  headers: off
			 mode: list
		nullvalue: ""
		   output: stdout
		separator: "|"
			width: 
		sqlite> drop table test;������ .dump ��������ļ�
		sqlite> drop view schema; ���Ƴ��Ѿ����ڵ����ݿ����
		sqlite> .read file.sql
		
	�򿪻��ԣ�����������������ʾ����
		sqlite> .echo on
		
	�մ����ַ���ʾ��
		sqlite> .nullvalue NULL
		
	����������ʾ����
		sqlite3>.prompt 'sqlite3> '
		
	���������ʽ��csv��column��html��insert��line��list��Ĭ�ϣ���tabs��tcl
		sqlite3> .mode list
		
	���ݣ�
		[sqlite]# sqlite3 test.db .dump > test.sql
		��
		sqlite> .output file.sql
		sqlite> .dump
		sqlite> .exit
		��
		[sqlite]# echo ".dump" | sqlite3 ex1 | gzip -c > ex1dmp.gz 
		
	���뱸�ݣ�
		[sqlite]# sqlite3 test.db < test.sql
		
	�õ������Ƶ����ݿ��ļ�������
		[sqlite]# sqlite3 test.db VACUUM �ͷ����ݿ��ļ���δʹ�õĿռ�
		[sqlite]# cp test.db test.backup
		
	�� sql ���д���ļ������ⲿ������
		[test]# vim create_exam.sql 
		create table exam
		(
				id integer primary key,
				value text
		);
		[test]# sqlite3 exam.db < create_exam.sql
		
	ɾ���������ݣ�
		sqlite> delete from exam where id=1;

	�ع����ݿ������
		zcat ex1dmp.gz | sqlite3 ex2 
		��SQLite3����ȡ���ݣ������������е����ݿ��У�

	��SHELL��ʹ��SQLite3����� 
		# sqlite3 demo.db "select * from t"
