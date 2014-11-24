## sipp2asterisk.sh 相关

### 使用范例：
	[sipp]# cd register/
	[register]# ../sipp2asterisk.sh --register 3001-register

### 三个文件夹：
	register	注册测试
	outgoing-unau	不带验证外呼测试
	outgoing-au	带验证外呼测试

* 注册测试：
	../sipp2asterisk.sh --register filename
* 带验证的外呼测试：
	../sipp2asterisk.sh --outgoing-au filename
* 不带验证的外呼测试：
	../sipp2asterisk.sh --outgoing-unau filename

	注：filename不带后缀
	脚本帮助信息：
		sipp2asterisk.sh -h
		sipp2asterisk.sh --help

### 配置文件：
#### filename.conf 保存 SIPp 相关参数信息
	# 本地IP，SIPp侧
	local_ip=172.16.8.181
	# 远端服务器IP和Port
	remote_ip=172.16.8.88
	remote_port=5060
	# CSV文件
	csv_file=3001-outgoing-unau.csv
	# 每个呼叫的呼叫时长
	duration=60000
	# 总的呼叫数量，为空表示持续呼叫
	max_calls=
	# 最大并发呼叫数
	max_simultaneous=10
	# 呼叫速率
	# 如果 call_rate=10 和 call_rate_period=65000，每65s将产生10个呼叫
	call_rate=10
	call_rate_period=65000

#### filename.csv 保存SIP用户信息

#### .xml 描述SIP流程

===== create-sip.sh 说明 =====
为Asterisk批量创建SIP账号
create-sip.sh --dynamic|--ip2ip|-h [new_sip_file]
	--dynamic	批量创建host=dynamic类型SIP账号
	--ip2ip		批量创建IP2IP类型SIP账号
	-h		帮助

