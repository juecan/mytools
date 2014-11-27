#!/bin/sh

ip=`echo $1 | sed 's/*/./g'`

echo $ip | grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$" >/dev/null
if [ $? = 1 ]; then
	exit 1
fi

var1=`echo $ip | awk -F. '{print $1}'`
var2=`echo $ip | awk -F. '{print $2}'`
var3=`echo $ip | awk -F. '{print $3}'`
var4=`echo $ip | awk -F. '{print $4}'`

for var in $var1 $var2 $var3 $var4
do
	if [ $var -gt 255 ] || [ $var -lt 0 ]; then
		exit 2
	fi
done

file=/etc/asterisk/gw/network/lan.conf

sed -i "s/type=.*/type=static/" $file
sed -i "s/ipaddr=.*/ipaddr=${ip}/" $file

mode=`cat $file | grep "type=" | sed 's/type=//'`
if [ "$mode" = "static" ]; then
	ifconfig eth0 $ip > /dev/null 2>&1
fi
exit 0
