## Asterisk 13.1.0 INSTALL

	CentOS 6.5
	32 bit：--libdir=/usr/lib
	64 bit：--libdir=/usr/lib64
	
### 安装依赖

	安装 EPEL 源：linux/centos6.5-epel.md
	Asterisk 源码目录运行：./contrib/scripts/install_prereq install
	yum install sqlite-devel
	安装 pjproject: 
		32 bit: ./configure --libdir=/usr/lib && make dep && make && make install
		64 bit: ./configure --libdir=/usr/lib64 --enable-shared && make dep && make && make install
	
### 安装 Asterisk

	32 bit: ./configure --libdir=/usr/lib
	64 bit: ./configure --libdir=/usr/lib64
	make menuselect(选中 chan_pjsip)
	make && make install && make samples && make config