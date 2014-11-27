#!/bin/bash
#
# Filename: pc_info.sh

########## 系统信息 ##########
# 操作系统	pc_os
# 系统版本	system_version
# 内核版本	kernel_version
# 机器平台	pc_platform

pc_os=`uname -o`
system_version=`cat /etc/redhat-release 2>> /dev/null || cat /etc/issue.net 2>> /dev/null`
kernel_version="`uname -s` `uname -r`"
pc_platform=`uname -m`

########## CPU信息 ##########
# CPU信息 echo "`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`"
# CPU核数量
core_num=`cat /proc/cpuinfo | grep name | wc -l`
# CPU型号
cpu_version=`cat /proc/cpuinfo | grep name | cut -f2 -d: | cut -c 2-`

#echo "`cat /proc/cpuinfo | grep physical | uniq -c`"

# 逻辑CPU(logical CPU)个数
logical_cpu_num=`cat /proc/cpuinfo | grep "processor" | wc -l`
# 物理CPU(physical CPU)个数
physical_cpu_num=`cat /proc/cpuinfo | grep "physical id" | sort -u | uniq | wc -l`
# 每个物理CPU中Core的个数
core_num_per_phy_cpu=`cat /proc/cpuinfo | grep "cpu cores' | wc -l"`
# or core_num_per_phy_cpu=`cat /proc/cpuinfo | grep 'core id' | uniq |  wc -l`
# 每个物理CPU中逻辑CPU(可能是core，threads或both)的个数
logical_cpu_per_phy_cpu=`cat /proc/cpuinfo | grep "siblings"`

# CPU运行在32/64位环境
cpu_run_bit=`getconf LONG_BIT`

#############################################################################################################################
# 系统启动时间：
sys_start_time=`date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S"`
sys_run_time=`cat /proc/uptime | awk -F. '{run_days=$1 / 86400; run_hour=($1 % 86400)/3600; run_minute=($1 % 3600)/60; run_second=$1 % 60; printf("%d天%d时%d分%d秒", run_days, run_hour, run_minute, run_second)}'`
#############################################################################################################################

# 显示
# Chinese
echo "====================硬件信息===================="
echo -n "CPU"
case $core_num in
"1")
	echo -e "\t\t单核CPU"
	;;
"2")
	echo -e "\t\t双核CPU"
	;;
"4")
	echo -e "\t\t四核CPU"
	;;
*)
	echo -e "\t\t多核CPU"
	;;
esac
echo -e "处理器\t\t$cpu_version"
echo -e "机器平台\t$pc_platform"

echo "====================系统信息===================="
echo -e "操作系统\t$pc_os"
echo -e "系统版本\t$system_version"
echo -e "内核版本\t$kernel_version"
echo -e "当前CPU运行在${cpu_run_bit}bit环境"
echo -e "系统启动时间\t$sys_start_time"
echo -e "系统运行时间\t$sys_run_time"


# English
#echo -e "CPU info\t$cpu_version"

######################## 在Linux下查看文件系统的格式如EXT2,EXT3有几种方法 ##################
	#df -T
	#mount
	#cat /etc/fstab
