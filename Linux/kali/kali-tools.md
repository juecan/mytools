# 信息收集

## DNS 信息收集

	DNS: Domain Name System，域名系统。由解析器和域名服务器组成的
	域名服务器是指保存有该网络中所有的域名和对应 IP 地址，并具有将域名转换为 IP 地址功能的服务器
	DNS 使用 TCP 与 UDP 端口号都是 53，只要使用 UDP，服务器之间备份是用 tcp 连接
	
### dnsenum

	查询：dnsenum 域名
	爆破：dnsenum -f 字典文件 域名

	Zone Transfers: 区域传送，从域名服务器每隔一段时间要去主域名服务器上去查询更新，以保证数据的一致性
		区域传送过程使用 TCP 协议 ，53 号端口
	
	dnsenum 的目的是尽可能收集一个域的信息，http://code.google.com/p/dnsenum/
		1) 主机地址信息，(A record)
		2) 域名服务器 (threaded)
		3) MX record (threaded)
		4) 在域名服务器上执行 axfr 请求
		5)通过 google 脚本得到扩展域名或子域名信息(google query = “allinurl: -www site:domain”)
		6) 提取子域名并查询
		7) 计算 C 类地址，并执行 whois 查询
		8) 执行反向查询
		9) 把地址段写入文件 domain_ips.txt
	查询：dnsenum baidu.com
	爆破：dnsenum --enum -f dns.txt --update a -r remote
	
### dnsmap

	使用 google 搜索引擎取额外的名字与子域名
	非常类似于 dnsenum，可以使用内建的“密码字典”来暴力破解子域名，也可以使用用户自定义的字典
		查询：dnsmap 域名
		常用参数命令举例：dnsmap –baidu.com -w dns.txt –c baidu.csv 扫描并保存在 baidu.csv 文件

## traceroute 路由信息收集

	现代 Linux 系统称为 tracepath，Windows 系统称为 tracert
	可显示数据包在 IP 网络经过的路由器的 IP 地址
	
	程序利用增加存活时间（TTL）值来实现其功能
	每当数据包经过一个路由器，其存活时间就会减 1，当其存活时间是 0 时，主机便取消数据包，并传送一个 ICMP TTL 数据包给原数据包的发出者
	程序发出的首 3 个数据包 TTL 值是 1，之后 3 个是 2，如此类推，它便得到一连串数据包路径
	注意 IP 不保证每个数据包走的路径都一样
	
### 原理
	首先给目的主机发送一个 TTL=1 的 UDP 数据包（每次送出的为 3 个 40 字节的包，包括源地址，目的地址和包发出的时间标签）
	经过的第一个路由器收到这个数据包以后，就自动把 TTL 减 1
	而 TTL 变为 0 以后，路由器就把这个包给抛弃了，并同时产生一个主机不可达的 ICMP 数据报（ICMP time exceeded）给主机
	主机收到这个数据报以后再发一个 TTL=2 的 UDP 数据报给目的主机，然后刺激第二个路由器给主机发 ICMP 数据 报
	如此往复直到到达目的主机。这样，traceroute 就拿到了所有的路由器 ip。从而避开了 ip 头只能记录有限路由 IP 的问题。

### 如何知道 UDP 到没到达目的主机：

	TCP 和 UDP 协议有一个端口号定义，而普通的网络程序只监控少数的几个号码较 小的端口，比如说 80, 23, 等等
	traceroute 发送的是端口号 >30000 的 UDP 报
	到达目的主机的时候，目的 主机只能发送一个端口不可达的 ICMP 数据报（ICMP port unreachable）给主机
	主机接到这个报告以后就知道，主机到了
	
### 实例

	[root@localhost ~]# traceroute www.baidu.com
	traceroute to www.baidu.com (61.135.169.125), 30 hops max, 40 byte packets
	1 192.168.74.2 (192.168.74.2) 2.606 ms 2.771 ms 2.950 ms
	2 211.151.56.57 (211.151.56.57) 0.596 ms 0.598 ms 0.591 ms
	3 211.151.227.206 (211.151.227.206) 0.546 ms 0.544 ms 0.538 ms
	4 210.77.139.145 (210.77.139.145) 0.710 ms 0.748 ms 0.801 ms
	5 202.106.42.101 (202.106.42.101) 6.759 ms 6.945 ms 7.107 ms
	6 61.148.154.97 (61.148.154.97) 718.908 ms * bt-228-025.bta.net.cn (202.106.228.25) 5.177 ms
	7 124.65.58.213 (124.65.58.213) 4.343 ms 4.336 ms 4.367 ms
	8 202.106.35.190 (202.106.35.190) 1.795 ms 61.148.156.138 (61.148.156.138) 1.899 ms 1.951 ms
	9 * * *
	30 * * *
	[root@localhost ~]# 

	记录按序列号从 1 开始，每个纪录就是一跳
	每一跳表示一个网关
	每行有三个时间：探测数据包向每个网关发送三个数据包后，网关响应后返回的时间
	有一些行是以星号表示：可能是防火墙封掉了 ICMP 的返回信息，所以我们得不到什么相关的数据包返回数据

### tcptraceroute

	就算在目标之前存在防火墙，它阻止了普通 traceroute 的流量，但是适当 TCP 端口的流量，防火墙是放行的，所以 tcptraceroute 能够穿越防火
墙抵达目标
	然而, 在许多情况下, 这些防火墙允许某些 TCP Port 封包进入后端的主机，藉由发送 TCP SYN 封包取代 UDP 或 ICMP ECHO 封包，tcptraceroute 能够通过大部份的防火墙过滤条例
	
## All-one 智能收集

	在实际入侵中，我们经常需要首先拿到目标站的域名信息，其中包括注册人信息，邮箱资料，DNS 服务器等信息为后续的入侵及社工做准备
	Maltego 是一个开放源的智能信息收集工具(域名 DNS Whois 信息 网段 IP 地址)，还能够收集人的信息，包含公司或者组织关联到的人、电邮、电话等级
	
	Maltego - Manage - Discover Transforms (Advanced) - 添加如下 URL：
		http://cetas.paterva.com/CE3Seed.xml
		http://maltego4.paterva.com/CESeed.xml
		
# 扫描工具

## 主机发现

### ping
### arping

### Fping

	与 ping 命令非常类似，使用 ICMP ECHO 一次请求多个主机
	-s 报表 –r 次数 –g 范围
		root@kali:~# fping -s -r 1 -g 172.16.8.180 172.16.8.189
		172.16.8.180 is alive
		172.16.8.181 is alive
		172.16.8.182 is alive
		172.16.8.184 is alive
		172.16.8.183 is unreachable
		172.16.8.185 is unreachable
		172.16.8.186 is unreachable
		172.16.8.187 is unreachable
		172.16.8.188 is unreachable
		172.16.8.189 is unreachable

			  10 targets
			   4 alive
			   6 unreachable
			   0 unknown addresses

			   6 timeouts (waiting for response)
			  16 ICMP Echos sent
			   4 ICMP Echo Replies received
			   0 other ICMP received

		 0.05 ms (min round trip time)
		 1.52 ms (avg round trip time)
		 5.22 ms (max round trip time)
				1.508 sec (elapsed real time)

### Genlist

	获取使用清单，通过 ping 探针的响应
	kali 中没有此工具

### Nbtscan

	扫描一个 IP 地址范围的 NetBIOS 名字信息，它将提供一个关于 IP 地址，NetBIOS 计算机机名，服务可用性，登录用户名和 MAC 地址的报告
	只针对 windowns
	root@kali:~# nbtscan 172.16.8.1-254
	Doing NBT name scan for addresses from 172.16.8.1-254

	IP address       NetBIOS Name     Server    User             MAC address      
	------------------------------------------------------------------------------
	172.16.8.7       SVOLTA-PC        <server>  <unknown>        6c:62:6d:c9:df:78
	172.16.8.148     3CX-SERVER                 <unknown>        00:0c:29:3f:75:49
	172.16.8.180     ALONG            <server>  <unknown>        12:24:36:48:60:72
	
### Nping

	允许用户产生各种网络数据包（TCP，UDP，ICMP，ARP），也允许用户自定义协议头部，例如：源和目的，TCP 和 UDP 的端口号
	root@kali:~# nping -c 1 --tcp -p 80 --flags syn 172.16.0.1

	Starting Nping 0.6.46 ( http://nmap.org/nping ) at 2014-12-31 11:54 CST
	SENT (0.0453s) TCP 10.0.2.15:65207 > 172.16.0.1:80 S ttl=64 id=27694 iplen=40  seq=1371649083 win=1480 
	 
	Max rtt: N/A | Min rtt: N/A | Avg rtt: N/A
	Raw packets sent: 1 (40B) | Rcvd: 0 (0B) | Lost: 1 (100.00%)
	Nping done: 1 IP address pinged in 1.05 seconds
	
## 操作系统指纹

	Netifera（kali 中没有此工具）
	
## 操作系统端口扫描

### p0f

	p0f -i eth1 -o log.txt
	
### xprobe2

	xprobe2 IP/24

### NMAP

	综合性的，并且特性丰富的端口扫描工具
	渗透测试都的必备工具
	功能：（主机发现、服务于版本检测、操作系统检测、网络追踪、nmap 脚本引擎）
		-v 列表 –n 不反向解析 –sP 扫描的协议

	root@kali:~# nmap -v -n -sP 172.16.8.180-190

	Starting Nmap 6.46 ( http://nmap.org ) at 2014-12-31 11:59 CST
	Initiating ARP Ping Scan at 11:59
	Scanning 10 hosts [1 port/host]
	Completed ARP Ping Scan at 11:59, 0.21s elapsed (10 total hosts)
	Nmap scan report for 172.16.8.180
	Host is up (0.000078s latency).
	MAC Address: 12:24:36:48:60:72 (Unknown)
	Nmap scan report for 172.16.8.181
	Host is up (0.0020s latency).
	MAC Address: 00:11:2F:A4:DC:A3 (Asustek Computer)
	Nmap scan report for 172.16.8.183 [host down]
	Nmap scan report for 172.16.8.184
	Host is up (0.00069s latency).
	MAC Address: 00:02:E7:F5:00:01 (CAB GmbH & Co KG)
	Nmap scan report for 172.16.8.185 [host down]
	Nmap scan report for 172.16.8.186 [host down]
	Nmap scan report for 172.16.8.187 [host down]
	Nmap scan report for 172.16.8.188 [host down]
	Nmap scan report for 172.16.8.189 [host down]
	Nmap scan report for 172.16.8.190 [host down]
	Nmap scan report for 172.16.8.182
	Host is up.
	Read data files from: /usr/bin/../share/nmap
	Nmap done: 11 IP addresses (4 hosts up) scanned in 0.32 seconds
			   Raw packets sent: 17 (476B) | Rcvd: 3 (84B)
			   
	nmap --script=脚本名 目标IP
			   
## 漏洞发现

### Nessus

	非常知名并且功能强大的综合漏洞发现工具，有免费与收费两种版本
	
## 漏洞分析

	sqlmap
	brupsuite
	
	注入方式爆破数据库：
	sqlmap -u URL --dbs											爆数据库
	sqlmap -u URL -D 数据库名 --tables							爆数据表
	sqlmap -u URL -D 数据库名 -T 数据表名 --columns				爆列
	sqlmap -u URL -D 数据库名 -T 数据表名 -C 列名,列名 --dump	爆数据
	
	brupsuite 设置代理为本地 127.0.0.0，端口 8080
	设置火狐代理为本地 127.0.0.0，端口 8080
	
## 社会工程学

### ettercap

	vim /etc/ettercap/etter.dns
		# redirect it to www.linux.org
		mail.163.com	A	192.168.1.120
		mail.163.com	PTR	192.168.1.120
		192.168.1.120 为攻击者 IP
		
### settoolkit

## metasploit

	Metasploit 使用 PostgreSQL 作为数据库：
		root@kali:~# /etc/init.d/postgresql start
	用 ss -ant 的输出来检验 PostgreSQL 是否在运行，然后确认 5432 端口处于 listening 状态：
		root@kali:~# ss -ant
	启动 Kali 的 Metasploit 服务：
		第一次运行服务会创建一个 msf3 数据库用户和一个叫 msf3 的数据库。
		还会运行 Metasploit RPC 和它需要的 WEB 服务端。
		root@kali:~# /etc/init.d/metasploit start
	在 Kali 运行 msfconsole：
		root@kali:~# msfconsole
	用 db_status 命令检验数据库的连通性
		msf > db_status 
		[*] postgresql connected to msf3
		
	PostgreSQL 和 Metasploit 开机启动：
		update-rc.d postgresql enable
		update-rc.d metasploit enable
