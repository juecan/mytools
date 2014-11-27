#!/bin/sh

netmask=`echo $1 | sed 's/*/./g'`

echo $netmask | grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$" >/dev/null
if [ $? = 1 ]; then
        exit 1
fi

var1=`echo $netmask | awk -F. '{print $1}'`
var2=`echo $netmask | awk -F. '{print $2}'`
var3=`echo $netmask | awk -F. '{print $3}'`
var4=`echo $netmask | awk -F. '{print $4}'`

for var in $var1 $var2 $var3 $var4
do
        if [ $var -gt 255 ] || [ $var -lt 0 ]; then
                exit 2
        fi
done

file=/etc/asterisk/gw/network/lan.conf

sed -i "s/netmask=.*/netmask=${netmask}/" $file

mode=`cat $file | grep "type=" | sed 's/type=//'`
if [ "$mode" = "static" ]; then
	ip=`cat $file | grep "ipaddr=" | sed 's/ipaddr=//'`
	ifconfig eth0 $ip netmask $netmask > /dev/null 2>&1
elif [ "$mode" = "dhcp" ]; then
	ps | while read line;do
	NAME=`echo $line | awk '{print $5$7}'`
	if [ "$NAME" = "udhcpceth0" ]; then
		PID=`echo $line | awk '{print $1}'`
		kill -9 $PID
	fi
	done
	udhcpc -i eth0 -t 3 -n &
fi
exit 0
