#!/bin/bash
#
# Author: Michael.zou
# Function: setup multiple sip account
# Date: 2014-04-21

##################################################
# config SIP function
##################################################

# set_sip_config first_sip sip_count sip_context host_type ipaddr
function set_sip_config()
{
        first=$1
        count=$2
	context=$3
	host_type=$4
	ipaddr=$5

        for name in `seq ${first} $[${first} + ${count} - 1]`
        do
                echo "[${name}]"
                echo "type=friend"
                case ${host_type} in
		"dynamic")
			echo "host=dynamic" ;;
		"ip2ip")
			echo "host=${ipaddr}"
			echo "fromuser=${name}"
			echo "insecure=invite"
			;;
		*)
			echo "Invalid value!"
			exit 0
			;;
		esac
                echo "username=${name}"
                echo "secret=${name}"
                echo "context=${context}"
                echo ""
        done
}

# set up SIP account
# set_sip options sip_file new_sip_file
function set_sip()
{
        echo -n "First SIP Account: "
        read first_sip
        echo -n "SIP count: "
        read sip_count
        echo -n "SIP context: "
        read sip_context
	[ "$1" == "ip2ip" ] && echo -n "Romote IP: " && read remote_ip

	echo -e "#include \"`basename ${new_sip_file}`\"" >> $2
	echo -n "Include your SIP file in $2: " && tail -1 $2
	set_sip_config ${first_sip} ${sip_count} ${sip_context} $1 ${remote_ip} >> $3
	echo "Your SIP file is: $3"
}

set_sip_usage()
{
	echo "Usage: `basename $1` --dynamic|--ip2ip|-h <new_sip_file>"
}

set_sip_help()
{
	echo
	set_sip_usage $1
	echo "Function: setup multiple sip account"
	echo
	echo -e "\t--dynamic\tSet host=dynamic"
	echo -e "\t--ip2ip\t\tSet host=IP"
	echo -e "\t-h\t\tDisplay usage"
	echo -e "\t--help\t\tDisplay this help"
	echo
}

##################################################
# Main function
##################################################

[ "$#" != "1" -a "$#" != "2" ] && set_sip_usage $0 && exit 0

case $1 in
"--dynamic") options=dynamic ;;
"--ip2ip") options=ip2ip ;;
"-h") set_sip_usage $0 && exit 0 ;;
"--help") set_sip_help $0 && exit 0 ;;
esac
[ "$2" == "" ] && echo "You need input a filename: `basename $0` --dynamic|--ip2ip new_sip_file" && exit 0

sip_file=/etc/asterisk/sip.conf
new_sip_file=/etc/asterisk/$2.conf
set_sip ${options} ${sip_file} ${new_sip_file}

