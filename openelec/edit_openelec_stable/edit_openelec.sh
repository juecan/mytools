#!/bin/bash

# copy_system orig_dir new_dir
copy_system()
{
	orig_dir=$1
	new_dir=$2

	#echo "检查空闲空间..."
	echo "Verifying free space..."
	free_space=`df /storage | grep dev | awk {'print $4'}`
	if [ ${free_space} -lt 400000 ]
	then
		#echo "/storage 没有足够空间！"
		echo "Not enough space left in /storage!"
		exit
	fi

	#echo "创建文件夹"
	echo "Making directories..."
	mkdir ${orig_dir}
	mkdir ${new_dir}

	#echo "挂载 SYSTEM..."
	echo "Mounting SYSTEM..."
	mount -t squashfs -o loop /flash/SYSTEM ${orig_dir}
	sleep 10
	if mount | grep "on ${orig_dir} type" > /dev/null
	then
		#echo "SYSTEM 已经挂载。"
		echo "SYSTEM mounted."
	else
		#echo "挂载 SYSTEM 出错！"
		echo "Error mounting SYSTEM!"
		exit
	fi

	#echo "拷贝文件，请稍后..."
	echo "Copy files, please wait..."
	cp -a ${orig_dir}/* ${new_dir}

	#echo "卸载 SYSTEM。"
	echo "Umounting SYSTEM."
	umount ${orig_dir}
	rm -r ${orig_dir}

	#echo "你可以修改 /storage/system.new 中的文件。"
	echo "You can edit files in ${new_dir}."
}

# pack_system new_dir
pack_system()
{
	new_dir=$1

	#echo "压缩新的 SYSTEM，拷贝到更新目录..."
	echo "Squashing new SYSTEM, copying to update directory..."
	if [ ! -d "/storage/.update" ]
	then
		mkdir -p /storage/.update
	fi
	chmod +x mksquashfs
	./mksquashfs ${new_dir} /storage/.update/SYSTEM
	chmod -x mksquashfs
	chmod 755 /storage/.update/SYSTEM
	cp /flash/KERNEL /storage/.update/

	#echo "产生 md5 校验文件..."
	echo "General md5 file..."
	md5sum /storage/.update/SYSTEM > /storage/.update/SYSTEM.md5
	md5sum /storage/.update/KERNEL > /storage/.update/KERNEL.md5

	rm -r ${new_dir}
	#echo "所有工作完成，重启后更新！"
	echo "All done. Reboot to upgrade!"
}

# change_passwd new_dir
change_passwd()
{
	new_dir=$1

	#echo -n "请输入用户名："
	echo -n "Please input usename: "
	read user
	#echo -n "请输入新的密码："
	echo -n "Please input new password: "
	read -s password
	echo

	#echo "正在更改 ${USER} 的密码，请稍后……"
	echo "Changing ${USER}'s password, please wait..."
	chmod +x change_password.py
	./change_password.py -p ${new_dir}/etc/ -u ${user} ${password}
	chmod -x change_password.py

	#echo "密码修改完毕。"
	echo "Password has been changed."
}

# help_info script_name new_dir
help_info()
{
	script_name=$1
	new_dir=$2

	echo "Usage: ${script_name} first|passwd|end|--help|-h|--version"
	echo "Modify OpenELEC read-only system."
	echo
	echo -e "\t1. ${script_name} first"
	echo -e "\t2. Modify, eg: ${script_name} passwd"
	echo -e "\t3. ${script_name} end"
	echo
	echo "About arguments:"
	echo -e "\tfirst\t\tThe first step: mount and copy SYSTEM to ${new_dir}."
	echo -e "\t\t\tso that you can edit the configuration files in ${new_dir}."
	echo -e "\tend\t\tThe end step: General the new SYSTEN and KERNEL file to update folder."
	echo -e "\tpasswd\t\tChange user's password."
	echo
	echo -e "\t-h\t\tDisplay short usage."
	echo -e "\t--help\t\tDisplay this help and exit"
	echo -e "\t--version\tOutput version information and exit"
	echo
}

VERSION=0.0.1
ORIG_DIR=/storage/system.orig
NEW_DIR=/storage/system.new

if [ $# != 1 ]
then
	echo "You need one parameter!"
	echo "Usage: $0 first|passwd|end|--help|-h|--version"
	exit
fi

case $1 in
"first")
	copy_system ${ORIG_DIR} ${NEW_DIR}
	;;
"end")
	pack_system ${NEW_DIR}
	;;
"passwd")
	change_passwd ${NEW_DIR}
	;;
"--version")
	echo "$0 version: ${VERSION}"
	;;
"-h")
	echo "Usage: $0 first|passwd|end|--help|-h|--version"
	;;
"--help")
	help_info $0 ${NEW_DIR}
	;;
*)
	echo "Error: Invalid parameter!"
	echo "Usage: $0 first|passwd|end|--help|-h|--version"
	;;
esac

