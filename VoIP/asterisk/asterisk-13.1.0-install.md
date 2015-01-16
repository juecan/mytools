## Asterisk 13.1.0 INSTALL

	CentOS 6.5
	
### 安装 Asterisk

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