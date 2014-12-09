## SIPp 作为 Server 运行

	sipp -sf XML_FILE -p 5060 -i SIPp_IP -rsa Caller_IP:5060 -trace_msg

### 使用 SIPp 测试巴西客户问题（SIP 消息测试）

	sipp -sf uas_basic.xml -p 5060 -i SIPp_IP -rsa OpenVoxGatewayIP:Port

	sipp -sf sip_cc_oe_ce_v_038.xml -p 5060 -i 172.16.8.181 -rsa 172.16.6.234:5060 -trace_msg
	其中：
		172.16.8.181 为 SIPp 地址
		172.16.6.234 为 GSM Gateway 地址
		sip_cc_oe_ce_v_038.xml：GW 发 invite -> SIPp 回 600 -> SIPp 回 500 -> GW 应发一个 ACK 而不是两个