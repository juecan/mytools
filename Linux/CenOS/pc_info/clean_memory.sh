#!/bin/bash
# 释放内存

#dmidecode | grep -A16 "Memory Device$"

free_memory() {
	echo "=================================================="
	echo "===================== 内存清理 ==================="
	echo "=================================================="
	echo "="

	total_mem=$(free -m | sed -n "2p" | awk '{print substr($2,1)}')
	remain_mem=$(free -m | sed -n "2p" | awk '{print substr($4,1)}')
	echo "= 总内存：${total_mem}M"
	echo "= 剩余内存：${remain_mem}M"
	echo "="

	echo -n "是否将所有未写的系统缓冲区写到磁盘中（Y/N）："
	read val_if
	if [ ${val_if} = "Y" -o ${val_if} = "y" ]
	then
		# 将所有未写的系统缓冲区写到磁盘中
		# 包含已修改的 i-node、已延迟的块 I/O 和读写映射文件
		echo "将所有未写的系统缓冲区写到磁盘中..."
		sync
	elif [ ${val_if} = "N" -o ${val_if} = "n" ]
	then
		echo "不将所有未写的系统缓冲区写到磁盘中！"
	else
		echo "输入错误！"
		echo "不将所有未写的系统缓冲区写到磁盘中！"
	fi

	echo "释放缓存："
	echo "1. 释放页缓存"
	echo "2. 释放 dentries, inodes"
	echo "3. 释放所有缓存"
	echo -n "请选择（1/2/3）："
	read val_if
	case ${val_if} in
	1)
		echo "释放页缓存……"
		echo 1 > /proc/sys/vm/drop_caches
		;;
	2)
		echo "释放 dentries, inodes..."
		echo 2 > /proc/sys/vm/drop_caches
		;;
	3)
		echo "释放所有缓存……"
		echo 3 > /proc/sys/vm/drop_caches
		;;
	*)
		echo "输入错误，退出！"
		exit
	esac

	remain_mem=$(free -m | sed -n "2p" | awk '{print substr($4,1)}')
	echo "= 总内存：${total_mem}M"
	echo "= 剩余内存：${remain_mem}M"
}

free_memory
