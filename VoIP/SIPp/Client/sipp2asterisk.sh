#!/bin/bash
# Author: Michael.zou
# Date: 2014-10-23

##################################################
# Functions
##################################################
# config_csv filename
config_csv()
{
	sip_csv_file=$1.csv

	echo "========== Create your own sip file! =========="
	echo -n "First Username: "
	read first
	echo -n "Count: "
	read count
	echo -n "Call num: "
	read callnum

	echo -n "Read type(sequence/random/user)(s/r/u): "
	read order
	case ${order} in
	S|s) echo "SEQUENTIAL" > ${sip_csv_file} ;;
	R|r) echo "RANDOM" > ${sip_csv_file} ;;
	U|u) echo "USER" > ${sip_csv_file} ;;
	*)
		echo "default value SEQUENTIAL"
		echo "SEQUENTIAL" > ${sip_csv_file}
		;;
	esac

	# csv file format: field0;field1;...;fieldn;
	#	field0: username
	#	field1: authentication info
	#	field2: call num
	for user in `seq ${first} $[${first} + ${count} - 1]`
	do
		echo "${user};[authentication username=${user} password=${user}];${callnum}" >> ${sip_csv_file}
		callnum=$[ ${callnum} + 1 ]
	done
}

# config_sipp_options filename
config_sipp_options()
{
	sipp_options_file=$1.conf
	csv_file=$1.csv

	default_ip=`ifconfig eth0 | sed -n "2p" | awk '{print substr($2,1)}' | cut -d ':' -f 2`
	echo -n "Your local ip (default: ${default_ip}): "
	read local_ip
	echo -n "Remote IP: "
	read remote_ip
	echo -n "remote_port (default: 5060): "
	read remote_port
	echo -n "Max Calls: "
	read max_calls
	echo -n "Call duration(default: 60000ms): "
	read duration
	echo -n "Call rate period: "
	read call_rate_period

	#[ "${duration}" == "" ] && duration=10000
	{
		echo "# local ip (SIPp)"
		echo "local_ip=${local_ip:=${default_ip}}"
		echo "# remote ip and port (eg: asterisk ip and port)"
		echo "remote_ip=${remote_ip}"
		echo "remote_port=${remote_port:=5060}"

		echo "# CSV file for SIPp"
		echo "csv_file=${csv_file}"

		echo "# duration for every call"
		echo "duration=${duration:=60000}"
		echo "# total of calls"
		echo "max_calls=${max_calls}"
		echo "# max simultaneous calls"
		echo "max_simultaneous=${max_simultaneous:=$[ $(cat ${csv_file} | wc -l) - 1 ]}"
		echo "# call rate"
		echo "# if call_rate=10 and call_rate_period=60000, it will general 10 calls every 60s"
		echo "call_rate=${call_rate:=$[ $(cat ${csv_file} | wc -l) - 1 ]}"
		echo "call_rate_period=${call_rate_period:=$[ ${duration} + 5000 ]}"
	}  > ${sipp_options_file}
}

# exec_sipp filename
exec_sipp()
{
	. $2.conf

	sipp_options="${remote_ip}:${remote_port}"
	sipp_options+=" -i ${local_ip}"

	case $1 in
	"register") sipp_options+=" -sf ${xml_file:=sipp-uac-register.xml}" ;;
	"outgoing-au") sipp_options+=" -sf ${xml_file:=sipp-uac-outgoing-au.xml}" ;;
	"outgoing-unau") sipp_options+=" -sf ${xml_file:=sipp-uac-outgoing-unau.xml}" ;;
	*) exit 1 ;;
	esac
	sipp_options+=" -inf ${csv_file}"

	[ "${max_simultaneous}" != "" ] && sipp_options+=" -l ${max_simultaneous}"
	[ "${max_calls}" != "" ] && sipp_options+=" -m ${max_calls}"
	[ "${duration}" != "" ] && sipp_options+=" -d ${duration}"
	[ "${call_rate}" != "" ] && sipp_options+=" -r ${call_rate}"
	[ "${call_rate_period}" != "" ] && sipp_options+=" -rp ${call_rate_period}"

	sipp_options+=" -trace_err -aa -default_behaviors all -oocsf ../ooc_default.xml"
	sipp ${sipp_options}
}

script_usage()
{
	echo "Usage: `basename $1` --register|--outgoing-au|--outgoing-unau|-h|--help [filename]"
}

# script_help script_name
script_help()
{
	#echo "Usage: $1 --register|--outgoing-unau|-h|--help [filename]"
	script_usage `basename $1`
	echo "SIPp test"
	echo
	echo "About arguments:"
	echo -e "\t--register filename\t\tUse sipp-uac-register.xml, register to UAS"
	echo -e "\t\t\t\t\tThe configuration file is \"filename\""
	echo -e "\t--outgoing-au filename\t\tUse sipp-uac-outgoing-au.xml, call to UAS"
	echo -e "\t\t\t\t\tThe configuration file is \"filename\""
	echo -e "\t--outgoing-unau filename\tUse sipp-uac-outgoing-unau.xml, call to UAS"
	echo -e "\t\t\t\t\tThe configuration file is \"filename\""
	echo -e "\t--h\t\t\t\tDisplay short help and exit"
	echo -e "\t--help\t\t\t\tDisplay this help and exit"
	echo
}

##################################################
# Main
##################################################

[ "$#" != "1" -a "$#" != "2" ] && script_usage $0 && exit 0

case $1 in
"-h") script_usage $0 && exit 0 ;;
"--help") script_help $0 && exit 0 ;;
"--register"|"--outgoing-au"|"--outgoing-unau")
	[ "$2" == "" ] && echo "You need input a filename: `basename $0` --register|--outgoing-unau filename" && exit 0
	filename=$2
	[ ! -f "${filename}.csv" ] && config_csv ${filename}
	[ ! -f "${filename}.conf" ] && config_sipp_options ${filename}
	[ "$1" == "--register" ] && exec_sipp register ${filename}
	[ "$1" == "--outgoing-au" ] && exec_sipp outgoing-au ${filename}
	[ "$1" == "--outgoing-unau" ] && exec_sipp outgoing-unau ${filename}
	;;
*) script_usage $0 && exit 0 ;;
esac

