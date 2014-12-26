## CentOS 6.5 下添加 epel 源

### 安装 yum 优先级插件

	yum install yum-priorities
	
### 安装 epel

	简介: https://fedoraproject.org/wiki/EPEL/zh-cn

	rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
	rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

### 查看是否安装成功

	rpm -q epel-release
	
### 导入 key

	rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
	
### 修改 /etc/yum.repos.d/epel.repo 文件

	在 [epel] 最后添加一条属性 priority=11
	意思是 yum 先去官方源查，官方没有再去 epel 的源找

### 重建缓存

	yum makecache