## Asterisk

### Asterisk 安装

	/etc/selinux/config：sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

	64 位机装 Asterisk 注意：
		32bit：./configure && make menuselect && make && make install && make samples
		64bit：./configure --libdir=/usr/lib64 && make menuselect && make && make install && make samples

	启动 DAHDI：service dahdi start
	启动 Asterisk：service asterisk start
	连接到 Asterisk CLI：asterisk -rvvv
		
	64 位机未按上述操作安装 Asterisk，出现的问题：
	Q：asterisk: error while loading shared libraries: libasteriskssl.so.1: cannot open shared object file: No such file or directory
	A：ln -s /usr/lib/libasteriskssl.so.1 /usr/lib64/libasteriskssl.so.1

	Q：No such command 'dahdi'
	A：cp /usr/lib/asterisk/modules/*  /usr/lib64/asterisk/modules/*
	A：启动时使用：/bin/sh /usr/sbin/safe_asterisk -U asterisk -G asterisk

### 安装 Asterisk 13.1.0

	CentOS 6.5

	cd pjproject-2.3
	32 bit: ./configure --libdir=/usr/lib --enable-shared
	64 bit: ./configure --libdir=/usr/lib64 --enable-shared
	make dep
	make
	make install
	
	cd dahdi-linux-complete-2.10.0.1+2.10.0.1
	make
	make install
	make config
	
	cd libpri-1.4.15
	make
	make install
	
	rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
	rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
	/etc/yum.repos.d/epel.repo:	在 [epel] 最后添加一条属性 priority=11
	yum makecache
	
	cd asterisk-13.1.0
	./contrib/scripts/install_prereq install
	yum install sqlite-devel
	32 bit: ./configure --libdir=/usr/lib
	64 bit: ./configure --libdir=/usr/lib64
	make menuselect(选中 chan_pjsip)
	make
	make install
	make config
	make samples
	
### asterisk 添加到 service 列表

	将 asterisk-version/contrib/init.d/ 中的 rc.redhat.asterisk 文件复制到 /etc/init.d，并重命名为asterisk。
	打开 asterisk 文件，将AST_SBIN=__ASTERISK_SBIN_DIR__改为实际路径（/usr/sbin）
	chkconfig --add asterisk 
	chkconfig asterisk on
	
	添加 Asterisk 启动脚本到 /etc/init.d/（即：把 asterisk 添加进服务）：
	cd /usr/src/asterisk-11.0.0; make config
	