## PJSIP 对接 Chan_sip

	PJSIP: Asterisk-13.1.0, 172.16.8.188
	chan_sip: Asterisk-1.8.20.0, 172.16.8.88
	eyebeam: 172.16.8.180
	
### SIP Trunk

	trunk-1001: eyebeam
	trunk-1003(188) <-> trunk-1003(88)

#### 172.16.8.188: pjsip.conf

	[simpletrans]
	type=transport
	protocol=udp
	bind=0.0.0.0

	; trunk-1001: 用于软电话注册
	[trunk-1001]
	type=aor
	max_contacts=1
	remove_existing=yes

	[auth-1001]
	type=auth
	auth_type=userpass
	username=user-1001
	password=1001

	[trunk-1001]
	type=endpoint
	context=from-1001
	disallow=all
	allow=ulaw
	transport=simpletrans
	auth=auth-1001
	aors=trunk-1001
	
	; trunk-1002: 注册到 172.16.8.88(chan_sip)
	[aor-1002]
	type=aor
	contact=sip:trunk-1002@172.16.8.88

	[registration-1002]
	type=registration
	transport=simpletrans
	outbound_auth=auth-1002

	[auth-1002]
	type=auth
	auth_type=userpass
	username=trunk-1002
	password=1002

	[trunk-1002]
	type=endpoint
	context=from-1002
	disallow=all
	allow=ulaw
	allow=alaw
	transport=simpletrans
	aors=aor-1002
	
	; trunk-1003: ip(172.16.8.188) <-> ip(172.16.8.88)
	[trunk-1003]
	type=aor
	contact=sip:trunk-1003@172.16.8.88

	[identify-1003]
	type=identify
	endpoint=trunk-1003
	match=172.16.8.88

	[trunk-1003]
	type=endpoint
	context=from-1003
	disallow=all
	allow=ulaw
	allow=alaw
	transport=simpletrans
	aors=trunk-1003

	; trunk-1004: 接受 chan_sip 的注册
	; 尚未测试成功
	
#### 172.16.8.88: sip.conf
	
	; trunk-1002: 接受来自 172.16.8.188 的注册和呼叫
	[trunk-1002]
	username=user-1002
	secret=1002
	type=friend
	context=from-1002
	host=dynamic
	insecure=invite
	
	; trunk-1003: ip(172.16.8.88) <-> ip(172.16.8.188)
	[trunk-1003]
	username=user-1003
	secret=1003
	type=friend
	context=from-1003
	host=172.16.8.188
	insecure=invite

#### 172.16.8.180: eyebeam

	; 注册到 Asterisk-13.1.0
	display name: 1001
	user name: trunk-1001
	password: 1001
	authentication user name: user-1001
	domain: 192.168.0.120
	register with domain and receive incoming calls
	
### 拨号规则

#### 172.16.8.188: extensions.conf

	[from-1001]
	exten => _X.,1,Answer()
	exten => _X.,n,Dial(PJSIP/${EXTEN}@trunk-1002)
	exten => _X.,n,Hangup()

#### 172.16.8.88: extensions.conf
