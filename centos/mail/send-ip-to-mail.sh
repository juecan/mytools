#!/bin/bash
# Filename: send-ip-to-mail.sh

# 安装 mutt 和 msmtp
# 配置 msmtp
# vim ~/.msmtprc：
#	account default
#	host smtp.163.com
#	from zouhualong1012@163.com
#	auth plain
#	user zouhualong1012@163.com
#	password your_password
#	logfile /var/log/msmtp.log
# 配置 mutt：
# vim ~/.muttrc：
#	set sendmail="/usr/local/bin/msmtp"
#	set use_from=yes
#	set realname="Along"
#	set editor="vim"

# Check network availability
function check_email_network()
{
	while true
	do
		TIMEOUT=5
		SITE_TO_CHECK="www.163.com"
		RET_CODE=`curl -I -s --connect-timeout ${TIMEOUT} ${SITE_TO_CHECK} -w %{http_code} | tail -n1`
		if [ "x${RET_CODE}" = "x200" ]; then
			echo "Network is OK, it will send ip information to your e-mail."
			break
		else
			echo "Network not ready, please wait..."
			sleep 1s
		fi
	done
}

ETH0_IP_ADDR=`ifconfig eth0 | sed -n "2p" | awk '{print substr($2,1)}' | cut -d ':' -f 2`
theme="\"IP Address: ${ETH0_IP_ADDR}\""
email=Michael.zou@openvox.cn
#email=1975397620@qq.com
 
check_email_network

{
	echo "Current time: `date '+%F %T'`"
	ifconfig
} | mutt -s "${theme}" ${email}

