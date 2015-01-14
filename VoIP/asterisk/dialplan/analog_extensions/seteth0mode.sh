#!/bin/sh

mode=$1

if [ $mode -ne 1 ] && [ $mode -ne 2 ]; then
	exit 2
fi

ps | while read line;do
NAME=`echo $line | awk '{print $5$7}'`
if [ "$NAME" = "udhcpceth0" ]; then
        PID=`echo $line | awk '{print $1}'`
        kill -9 $PID
fi
done

file=/etc/asterisk/gw/network/lan.conf

if [ $mode -eq 1 ]; then
	sed -i "s/type=.*/type=static/" $file
	ip=`cat $file | grep "ipaddr=" | sed 's/ipaddr=//'`
	netmask=`cat $file | grep "netmask=" | sed 's/netmask=//'`
	gateway=`cat $file | grep "gateway=" | sed 's/gateway=//'`
	ifconfig eth0 $ip netmask $netmask > /dev/null 2>&1
	route del default dev eth0 >/dev/null 2>&1
	route add default gw $gateway dev eth0 >/dev/null 2>&1
elif [ $mode -eq 2 ]; then
	sed -i "s/type=.*/type=dhcp/" $file
	udhcpc -i eth0 -t 3 -n &
fi
exit 0
