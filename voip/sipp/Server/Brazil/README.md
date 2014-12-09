## 针对巴西大客户的网关测试

	SIPp 作为服务器端响应 GW 的 SIP 消息
	例如：sipp -sf uas_basic.xml -p 5060 -i 172.16.8.181 -rsa 172.16.179.1:5060 -trace_msg

	sipp -sf XML_FILE -p 5060 -i SIPpIP -rsa Gateway:5060 -trace_msg

### 客户问题

	voxmundi_sip_logs：包含客户的问题及网络数据包文件
	网络数据包文件中，192.168.0.109 为 OpenVox GSM Gateway，192.168.0.45 为 IP-PBX
	
### 测试设备

	SIM卡短号：66379，长号：15728748691
	

## 以下为测试场景
	
### SIP_RG_RT_V_010

	Q: 网关注册到 PBX，PBX 无响应，重新发起注册的超时时间应为 32s，但网关 20s 后便不重新注册
		重发 Register 周期：T1 = 500ms
			1 * T1 + 2 * T1 + 4 * T1 + 8 * T1 + 8 * T1 + 8 * T1 + 8 * T1 + 8 * T1 + 8 * T1 + 8 * T1 + 1 * T1
	A: 注册超时时间：SIP - Advanced SIP Settings - Parsing and Compatibility - Outbound Registrations - Registration Timeout
		默认为 20s，修改为 32s
	
	测试场景：sip_rg_rt_v_010.xml
	测试方法：
		1. SIPp 端：sipp -sf sip_rg_rt_v_010.xml -p 5060 -i 172.16.8.181 -rsa 172.16.179.1:5060 -trace_msg
		2. SIPp 端：tcpdump -s 0 -i enp4s2 -w test.pcap 抓包
		3. GW 端：
			1)建立 SIP Trunk
				Name: 8888
				User Name: 8888
				Password: 8888
				Registration: None
				Hostname or IP Address: 172.16.8.181
				Transport: UDP
				NAT Traversal: Yes
			2)将上面的 Registration: None 改为 Registration: This gateway register with the endpoint
		3. 检查 SIPp 或数据包，看是否在重传 REGISTER 32s 后接收到 Unexpected Message

![sip_rg_rt_v_010](images/sip_rg_rt_v_010.jpg)
		
### SIP_CC_OE_CE_V_038

	Q: 网关发送 INVITE 后，PBX 连续回复 600, 500，网关应只回复一条 ACK，没有重传的 ACK
	
	测试场景：sip_cc_oe_ce_v_038.xml
	测试方法：
		1. SIPp 端：sipp -sf sip_cc_oe_ce_v_038.xml -p 5060 -i 172.16.8.181 -rsa 172.16.179.1:5060 -trace_msg
		2. GW 端：
			1)建立 SIP Trunk
				Name: 8888
				User Name: 8888
				Password: 8888
				Registration: None
				Hostname or IP Address: 172.16.8.181
				Transport: UDP
				NAT Traversal: Yes
			2)建立 Routing Rule：
				gsm-1.1 -> sip-8888
			3)使用手机拨打 gsm-1.1
		3. 检查 SIPp 是否有重传 ACK 消息
		
![sip_cc_oe_ce_v_038](images/sip_cc_oe_ce_v_038.jpg)


