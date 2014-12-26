## DAHDI system.conf

### system.conf

	span=1,1,0,ccs,hdb3,crc4
	# termtype： te
	bchan=1-15,17-31   # 话音, 数据通道
	dchan=16           # 信令, 分组信息通道
	# Global data
	loadzone        = us
	defaultzone     = us

### span=<span num>,<timing source>,<line build out (LBO)>,<framing>,<coding>[,yellow]

	span num：表示 span 的数量,并且该数值从 1 开始。例如 D110P, span 的数量为 1, D210P, span 总数量为 2 (分别有 span1, span2)。
	timing source：时钟同步设定参数：(通常有如下几个值)
		0：当 timing=0 时，该卡的这个 span 将被设定为同步时钟源，并且发送时钟同步信号给远端。
		1：当 timing=1 时，该卡的这个 span 将被设定为主同步时钟源。
		2：当 timing=2 时，该卡的这个 span 将被设定为备选同步时钟源。。当 timing=3,4……也是备用，以此类推。
		当 timing=0 时，由 asterisk 提供时钟信号。如果 asterisk 服务器直接连入运营商，则 timing 应该设定为 1，用于接收从 telco 送来的时钟信号。
		当 timing=0 时，通常只用于网络端(net)而不是用户端(cpe)。
	LBO：表示运营商与 asterisk 服务器之间的距离，一般情况下都应该设定 LBO=0,除非它们之间的距离很长。
	framing：表示帧的格式。用于告知硬件(服务器)与远端如何通信。通常有以下几个值：
		T1 模式：d4 或者 esf
		E1 模式：cas 或者 ccs
	coding：表示通信编码。通常有如下几个值：
		T1 模式：ami 或者 b8zs
		E1 模式：ami 或者 hdb3(E1 有些时候需要 crc4 校验，需向运营商确认)

	注意：
		SS7 中不要打开 crc4，局端默认不作校验，打开 crc4 就会出现问题
		SS7 中不要设置 dchan

### channel

	bchan	话音，数据通道
	dchan	信令，分组信息通道

### zone

	loadzone	国家制式
	defaultzone	国家制式