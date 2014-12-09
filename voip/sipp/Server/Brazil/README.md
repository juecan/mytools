## 针对巴西大客户的网关测试

	SIPp 作为服务器端响应 GW 的 SIP 消息
	例如：sipp -sf uas_basic.xml -p 5060 -i 172.16.8.181 -rsa 172.16.179.1:5060 -trace_msg

	sipp -sf XML_FILE -p 5060 -i SIPpIP -rsa Gateway:5060 -trace_msg

## 测试设备

	SIM卡短号：66379，长号：15728748691

## 以下为测试场景
	
### SIP_RG_RT_V_010

	Q: 网关注册到 PBX，PBX 无响应，重新发起注册的超时时间应为 32s，但网关 20s 后便不重新注册
	A: 注册超时时间：SIP - Advanced SIP Settings - Parsing and Compatibility - Outbound Registrations - Registration Timeout
		默认为 20s，修改为 32s
	
### SIP_CC_OE_CE_V_038

	Q: 网关发送 INVITE 后，PBX 连续回复 600, 500，网关应只回复一条 ACK，没有重传的 ACK
	
	测试场景：sip_cc_oe_ce_v_038.xml
	测试方法：
		sipp -sf sip_cc_oe_ce_v_038.xml -p 5060 -i 172.16.8.181 -rsa 172.16.179.1:5060 -trace_msg
		检查是否有重传 ACK 消息
		
![sip_cc_oe_ce_v_038](images/sip_cc_oe_ce_v_038.jpg)


