#!/bin/bash

# 参数说明
# root用户权限UID       ROOT_UID
# 非root用户退出码      E_NOTROOT

# 检查是否为root用户
function check_root()
{
	ROOT_UID=0
	E_NOTROOT=67

	if [ "$UID" -ne "$ROOT_UID" ]
	then
		echo "必须拥有 root 权限才可以执行！"
		exit $E_NOTROOT
	fi
}

if [ $# != 1 ]
then
	echo "Usage: $0 start|stop|restart"
	exit 1
fi

# Q: No such file or directory: AH02291: Cannot access directory '/var/log/apache2/' for main error log
# -d 参数判断 $myPath 是否存在 
apache2_path=/var/log/apache2/
if [ ! -d "${apache2_path}" ]
then 
	mkdir -p "${apache2_path}" 
fi 

/etc/init.d/apache2 $1

