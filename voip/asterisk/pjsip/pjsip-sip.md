## PJSIP 对接
	
### SIP Trunk

#### 192.168.0.120: pjsip.conf

	[simpletrans]
	type=transport
	protocol=udp
	bind=0.0.0.0

	[trunk-1001]
	type=aor
	max_contacts=1
	remove_existing=yes

	[auth-1001]
	type=auth
	auth_type=userpass
	username=user-1001
	password = 1001

	[trunk-1001]
	type=endpoint
	context=from-1001
	disallow=all
	allow=ulaw
	transport=simpletrans
	auth=auth-1001
	aors=trunk-1001

#### 192.168.0.121: pjsip.conf

#### 192.169.0.107: eyebeam

	display name: 1001
	username: trunk-1001
	password: 1001
	authentication name: user-1001
	domain: 192.168.0.120
	register to domain

### 拨号规则

#### 192.168.0.120: extensions.conf

#### 192.168.0.121: extensions.conf
