# OpenVox GSM Gateway 上挂载 NFS

## （一）NFS 服务器配置

	本 NFS 服务器为 CentOS 5.9，CentOS 6 以上请将以下 portmap 改为 rpcbind

	安装相关软件：
	images/packages.jpg
	
	![alt text](images/packages.jpg)

	![alt text1][logo]

	[logo]: images/packages.jpg
	
	![github](images/packages.jpg "github") 
 
	配置允许访问的主机，编辑文件 /etc/hosts.allow：
 
	配置拒绝访问的主机，编辑文件 /etc/hosts.deny：
 
	配置共享目录信息，编辑文件 /etc/exports：
 
	使共享目录设置生效：
 
	启动NFS服务：
 
	检查NFS共享目录设置：
 
## （二）OpenVox GSM Gateway 挂载 NFS

	挂载 NFS 共享目录：
 
	在 NFS 共享目录中创建文件：
 
	在 NFS 服务器中查看创建的文件：
 
	卸载 NFS 共享目录：