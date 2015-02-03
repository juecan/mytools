# OpenVox GSM Gateway 出厂配置文件导出

1. 插上所有板卡，全部恢复出厂设置
2. 集群：先在 SYSTEM - Status 查看板卡状态
3. 创建 2 个 SIP 账号（SIP - SIP Endpoints）
4. 创建 2 条路由
5. 导出配置（SYSTEM - Tools - Download Backup）
6. 拔出最后一块板，进 SYSTEM - Status 查看板卡状态，最后一块板显示为空
7. 在 SYSTEM - Cluster 中去除最后一块板（拔出的那块板）的 IP，Manual Cluster
8. 进 SYSTEM - Status 查看板卡状态，空显示的那块板已被移除，再导出配置
7. 剩下最后一块板时，SYSTEM - Cluster - Mode - Stand-alone - Manual Cluster

## 手动集群

	SYSTEM - Cluster
		Detail ON
		Mode: Master Set Default
		Remain Original IP address: ON
		Action: Manual Cluster
		集群完后进 SYSTEM - Status 查看板卡状态

## 创建 2 个 SIP 账号

	PC-SIP: 
		Name: PC-SIP
		User Name: 6666
		Password: 6666
		Registrations: Endpoint registers with this gateway
		Hostname or IP Address: dynamic
		Others: default
		
	SIP-PBX:
		Name: SIP-PBX
		User Name: 1000
		Password: 1000
		Registrations: None
		Hostname or IP Address: 172.16.99.99
		Others: default

## 创建 2 条路由

	ROUTING - Groups:
		Group Name: ALLGSM
		Type: GSM
		Policy: Roundrobin
		All

	ROUTING - Call Routing Rules:
		Routing Name: GSM-IN
		Call Comes in From: ALLGSM
		Send Call Through: SIP-PBX

		Routing Name: GSM-OUT
		Call Comes in From: PC-SIP
		Send Call Through: ALLGSM
