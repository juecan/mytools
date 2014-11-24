#!/bin/bash
# Filename: ssh-remote.sh

SSH_REMOTE_LISTS=/home/along/bin/config/ssh/ssh_remote_lists
REMOTE_USER=
REMOTE_IP=
REMOTE_PORT=

if [ ! -f "${SSH_REMOTE_LISTS}" ]; then
	touch "${SSH_REMOTE_LISTS}"
fi

function get_remote_info()
{
	count=$1

	echo -e "\t1) 新建"
	for num in `seq 1 1 ${count}`
	do
		option=`sed -n "${num}p" ${SSH_REMOTE_LISTS} | cut -d ':' -f 2`
		echo -e "\t$[${num} + 1]) ${option}"
	done
	echo -e "\tq) quit"

	while [ "1" = "1" ]
	do
		echo -n "请选择 (1..$[${count} + 1] or q) -> "
		read sel
		case ${sel} in
		[0-9]|[0-9][0-9])
			[ ${sel} -lt 1 -o ${sel} -gt $[${count} + 1] ] && echo -e "错误：无效的参数，请输入 1 和 $[${count} + 1] 之间的数值！" && continue
			if [ ${sel} = "1" ]
			then
				echo -n "请输入远程服务器IP："
				read REMOTE_IP
				echo -n "请输入用户名："
				read REMOTE_USER
				echo -n "请输入端口号："
				read REMOTE_PORT
				echo "${REMOTE_USER}:${REMOTE_IP}:${REMOTE_PORT}" >> ${SSH_REMOTE_LISTS}
			else
				REMOTE_USER=`sed -n "$[${sel} - 1]p" ${SSH_REMOTE_LISTS} | cut -d ':' -f 1`
				REMOTE_IP=`sed -n "$[${sel} - 1]p" ${SSH_REMOTE_LISTS} | cut -d ':' -f 2`
				REMOTE_PORT=`sed -n "$[${sel} - 1]p" ${SSH_REMOTE_LISTS} | cut -d ':' -f 3`
			fi

			return 0
			;;
		q|Q)
			return 1
			;;
		esac
	done
}

get_remote_info `wc -l ${SSH_REMOTE_LISTS} | cut -d " " -f 1` && ssh ${REMOTE_USER}@${REMOTE_IP} -p ${REMOTE_PORT}

