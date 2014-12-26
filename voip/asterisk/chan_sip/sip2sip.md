## SIP 对接

	两台 asterisk 服务器 SIP 对接

	user -> register -> peer
	peer -> call -> user
	friend = user + peer
	
	eyebeam(trunk-1001, 107) -> trunk-1002(120) -> trunk-1002(121) -> trunk-1003(121) -> trunk-1003(120) -> Playback
	friend -------------------> peer ------------> user ------------> peer ------------> user
	dynamic ------------------> dynamic ---------> ip + register ---> ip + none -------> ip + none
	
### SIP Trunk

#### 192.168.0.120: sip.conf

	[trunk-1001]
	username=user-1001
	secret=1001
	type=friend
	host=dynamic
	context=from-1001

	[trunk-1002]
	type=peer
	host=dynamic
	username=user-1002
	secret=1002
	fromuser=trunk-1002
	insecure=invite
	context=from-1002

	[trunk-1003]
	type=user
	host=192.168.0.121
	username=user-1003
	secret=1003
	fromuser=trunk-1003
	insecure=invite
	context=from-1003

#### 192.168.0.121: sip.conf

	[general]
	register => trunk-1002:1002@192.168.0.120

	[trunk-1002]
	type=user
	host=192.168.0.120
	username=user-1002
	secret=1002
	fromuser=trunk-1002
	insecure=invite
	context=from-1002

	[trunk-1003]
	type=peer
	host=192.168.0.120
	username=user-1003
	secret=1003
	fromuser=trunk-1003
	insecure=invite
	context=from-1003

#### 192.169.0.107: eyebeam

	display name: 1001
	user name: trunk-1001
	password: 1001
	authentication user name: trunk-1001
	domain: 192.168.0.120
	register with domain and receive incoming calls

### 拨号规则

#### 192.168.0.120: extensions.conf

	[from-1001]
	exten => _X.,1,Dial(SIP/trunk-1002/${EXTEN})
	exten => _X.,n,Hangup()

	[from-1003]
	exten => _X.,1,Answer()
	exten => _X.,n,Playback(demo-instruct)
	exten => _X.,n,Hangup()

#### 192.168.0.121: extensions.conf

	[from-1002]
	exten => _X.,1,Dial(SIP/trunk-1003/${EXTEN})
	exten => _X.,n,Hangup()
