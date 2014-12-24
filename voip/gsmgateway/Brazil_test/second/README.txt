sip_cc_oe_ce_v_018.xml(new)
	sipp -sf sip_cc_oe_ce_v_018.xml -p 5060 -i 172.16.8.88 172.16.8.186:5060 -trace_msg
	Mobile -> GSM -> 8888 (none) -> SIPp
	网关收到 BYE 后应回复 200

sip_cc_oe_ce_v_019.xml(old)
	sipp -sf sip_cc_oe_ce_v_019.xml -p 5060 -i 172.16.8.88 172.16.8.186:5060 -trace_msg
	Mobile -> GSM -> 8888 (none) -> SIPp
	检查是否收到第二个 ACK
	* 此场景放在 asterisk 13，第二个 200OK Via 头域有问题

sip_cc_oe_ce_v_040.xml(new)
	sipp -sf sip_cc_oe_ce_v_040.xml -p 5060 -i 172.16.8.88 172.16.8.186:5060 -trace_msg
	Mobile -> GSM -> 8888 (none) -> SIPp
	603 后需回复一个 ACK
	* 此场景放在 asterisk 13，一直重发 ACK 和 603

*sip_cc_oe_ce_v_049.xml(new)
	sipp -sf sip_cc_oe_ce_v_049.xml -p 5060 -i 172.16.8.88 172.16.8.186:5060 -t t1 -trace_msg
	Mobile -> GSM -> 8888 (none) -> SIPp
	查看网关是否发送 INVITE
	SIP Advanced Settings - Enable TCP: Yes, SIP Endpoints - Transport: TCP
	网关测试 OK
	尚未在 asterisk 13 测试

*sip_cc_oe_ce_ti_012.xml(old)
	sipp -sf sip_cc_oe_ce_ti_012.xml -p 5060 -i 172.16.8.88 172.16.8.186:5060 -trace_msg
	Mobile -> GSM -> 8888 (none) -> SIPp
	32s后发的200OK不应该回ACK
	* 此场景在 asterisk 13 测试直接被挂断
	
sip_cc_oe_cr_ti_002.xml(new)
	sipp -sf sip_cc_oe_cr_ti_002.xml -p 5060 -i 172.16.8.88 172.16.8.186:5060 -trace_msg
	Mobile -> GSM -> 8888 (none) -> SIPp
	第一个重发的 BYE 与第一个应间隔 1s，而不是 4s
	* 此场景在 asterisk 13 测试直接被挂断

sip_cc_te_ce_v_020.xml(new)
	sipp -sf sip_cc_te_ce_v_020.xml -i 172.16.8.88 172.16.8.186:5060 -m 1 -trace_msg
	SIPp -> 8888 -> GSM -> Mobile
	抓包或者查看 SIPp log，发出 INVITE 后是否有回复
	* 此场景在 asterisk 13 测试回应 100Trying

sip_cc_te_ce_v_033.xml(new)
	sipp -sf sip_cc_te_ce_v_033.xml -i 172.16.8.88 172.16.8.186:5060 -m 1 -trace_msg
	SIPp -> 8888 -> GSM -> Mobile
	发出 ACK 后网关应终止 420
	* 此场景在 asterisk 13 测试 OK

sip_cc_te_ce_i_001.xml(new)
	sipp -sf sip_cc_te_ce_i_001.xml -i 172.16.8.88 172.16.8.186:5060 -m 1 -trace_msg
	SIPp -> 8888 -> GSM -> Mobile
	发出 ACK 后网关应终止 420
	* 此场景在 asterisk 13 测试 OK

sip_cc_te_ce_i_002.xml(new)
	sipp -sf sip_cc_te_ce_i_002.xml -i 172.16.8.88 172.16.8.186:5060 -m 1 -trace_msg
	SIPp -> 8888 -> GSM -> Mobile
	发出 ACK 后网关应终止 420
	* 此场景在 asterisk 13 测试 OK

sip_cc_te_ce_ti_007.xml(new)
	sipp -sf sip_cc_te_ce_ti_007.xml -i 172.16.8.88 172.16.8.186:5060 -m 1 -trace_msg
	SIPp -> 8888 -> GSM -> Mobile

有问题sip_mg_te_v_015.xml(old)
	SIP Advanced Settings - Enable TCP: Yes, SIP Endpoints - Transport: TCP
	sipp -sf sip_mg_te_v_015.xml -i 172.16.8.88 172.16.8.186:5060 -m 1 -t t1 -trace_msg

