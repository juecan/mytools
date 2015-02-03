* 172.16.0.2：Elastix，公司电话服务器，WEB: admin/openvox20!!，SSH: root/openvox20!!
* 172.16.0.11：IX110，对接公司电话服务器，SSH: root/openvox20!!

## 公司 IMS elastix 配置：

1. 准备一块网卡插入elastix服务器，具体网卡配置信息如下
	IP: 10.211.86.133
	NETMASK: 255.255.255.192 
	gateway: 10.211.86.129

2. 在linux shell中需要加入特定的路由信息：
	route add -net 10.211.0.0/16 gw 10.211.86.129

3. 在sip.conf [gerenal]中加入:
	externip=10.211.86.133
	localnet=172.16.0.0/255.255.0.0
	dtmfmode=inband

4. 配置文件sip_additional.conf加入sip配置：
	[8675561828725]
	disallow=all
	host=10.211.0.241
	username=8675561828725@ims.gd.chinamobile.com
	secret=123456
	type=friend
	insecure=port,invite
	fromdomain=ims.gd.chinamobile.com
	fromuser=+8675561828725
	allow=alaw
	context=from-trunk-sip-8675561828725
	
	[8675561828726]
	disallow=all
	host=10.211.0.241
	username=8675561828726@ims.gd.chinamobile.com
	secret=123456:q!
	type=friend
	insecure=port,invite
	fromdomain=ims.gd.chinamobile.com
	fromuser=+8675561828726
	allow=alaw
	context=from-trunk-sip-8675561828726
	
	[8675561828727]
	disallow=all
	host=10.211.0.241
	username=8675561828727@ims.gd.chinamobile.com
	secret=123456
	type=friend
	dtmfmode=inband
	insecure=port,invite
	fromdomain=ims.gd.chinamobile.com
	fromuser=+8675561828727
	allow=alaw
	dtmfmode=inband
	context=from-trunk-sip-8675561828727
	
	[8675561828729]
	disallow=all
	host=10.211.0.241
	username=8675561828729@ims.gd.chinamobile.com
	secret=123456
	type=friend
	insecure=port,invite
	fromdomain=ims.gd.chinamobile.com
	fromuser=+8675561828729
	allow=alaw
	context=from-trunk-sip-8675561828729

4.  配置文件sip_registrations.conf加入sip配置：
	register=+8675561828725@ims.gd.chinamobile.com:123456:8675561828725@ims.gd.chinamobile.com@10.211.0.241/+8675561828725
	register=+8675561828726@ims.gd.chinamobile.com:123456:8675561828726@ims.gd.chinamobile.com@10.211.0.241/+8675561828726
	register=+8675561828727@ims.gd.chinamobile.com:123456:8675561828727@ims.gd.chinamobile.com@10.211.0.241/+8675561828727
	register=+8675561828729@ims.gd.chinamobile.com:123456:8675561828729@ims.gd.chinamobile.com@10.211.0.241/+8675561828729

## 第二条 IMS 线路：（0755-66630978 的配置）
	由于此条线路的IP地址和网关和公司之前四个号码在一个网段，而且网关地址又一样，导致只能使用另外一台IX110的主板来做SIP中继，具体配置如下：

1. IX110服务器，具体网卡配置信息如下
	eth0:
		IP: 172.16.0.11
		NETMASK: 255.255.0.0
		gateway:172.16.0.1

	eth1
		IP: 10.211.86.136
		NETMASK: 255.255.255.192 
		gateway: 10.211.86.129

2. 在linux shell中需要加入特定的路由信息：
	route add -net 10.211.0.0/16 gw 10.211.86.129

3. 在sip.conf [gerenal]中加入:
	externip=10.211.86.136
	localnet=172.16.0.0/255.255.0.0
	dtmfmode=inband

4. 配置文件sip_additional.conf加入sip配置：
	[8675566630978]
	disallow=all
	host=10.211.0.241
	username=8675566630978@ims.gd.chinamobile.com
	secret=123456
	type=friend
	insecure=port,invite
	fromdomain=ims.gd.chinamobile.com
	fromuser=+8675566630978
	allow=alaw
	context=from-openvox
	
	[openvox]
	host=172.16.0.2
	insecure=invite
	canreinvite=no
	context=from-internal
	type=friend

4.  配置文件sip_registrations.conf加入sip配置：
	register=+8675566630978@ims.gd.chinamobile.com:123456:8675566630978@ims.gd.chinamobile.com@10.211.0.241/+8675566630978

5. 在extensions.conf中加入：
	[from-openvox]
	exten => _., 1, Dial(SIP/openvox/88998)
	exten => _., n, Hangup

6. 在公司的elastix服务器中加入一个sip trunk对接
	[8675566630978]
	host=172.16.0.11
	insecure=invite
	disallow=all
	allow=ulaw,alaw
	canreinvite=no
	context=from-pstn
	type=friend

