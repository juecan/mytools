#!/bin/sh

IPADDR=`ifconfig eth0 |awk -F '[ :]+' 'NR==2 {print $4}'`
echo $IPADDR |grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$" > /dev/null
if [ $? = 1 ]; then
    IPADDR=0.0.0.0
fi

echo "SAY ALPHA \"$IPADDR\" \"#*\""
exit 0
