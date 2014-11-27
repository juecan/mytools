#!/bin/sh

# Consume all variables sent by Asterisk
while read VAR && [ -n ${VAR} ]; do : ; done

echo "GET VARIABLE CHANNEL"
read RESPONSE
channel_id=`echo $RESPONSE|cut -c20-|cut -d'-' -f1`
channel_name=fxs-"$channel_id"-sip-
SIP=`awk "/$channel_name/" /etc/asterisk/extensions_fxs.conf |cut -d '-' -f4`

echo "SAY ALPHA \"$SIP\" \"#*\""
read RESPONSE
exit 0
