#!/bin/bash
# Filename: update_time.sh
# Author: 邹华龙
# Time: 2014/6/19
#
# 确保时区正确：
# /etc/sysconfig/clock：
#	ZONE="Asia/Shanghai"
#	tUTC=true
#	ARC=false

# 日期不对可能导致编译时出现：make: warning:  Clock skew detected.  Your build may be incomplete.

function update_sys_time()
{
	# 关闭 ntpd 服务
	service ntpd stop

	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

	# 联网更新时间
	ntpdate asia.pool.ntp.org
	#ntpdate us.pool.ntp.org

	# 同步 BIOS 时间
	hwclock -w

	# 校准后开启 ntpd 服务
	service ntpd start

}

echo "Before update:"
echo -ne "\tSystem Time: " && date
echo -ne "\tBIOS Time: " && hwclock -r

update_sys_time

echo "After update: "
echo -ne "\tSystem Time: " && date
echo -ne "\tBIOS Time: " && hwclock -r

