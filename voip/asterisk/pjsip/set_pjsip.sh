#!/bin/bash

# set_pjsip type trunkname username password origin_ip
set_pjsip()
{
	type=$1
	trunkname=$2
	username=$3
	password=$4
	origin_ip=$5
	echo "[${trunkname}]"
	echo "username = ${username}"
	echo ""
	if [ "${type}" == "ip2ip" ]
	then
		# ip->ip start
		echo "[${trunkname}]"
		echo "type = aor"
		echo "contact = sip:${username}@${origin_ip}"
		echo ""
		echo "[${trunkname}]"
		echo "type = identify"
		# or echo "type = auth"
		echo "endpoint = ${trunkname}"
		echo "match = ${origin_ip}"
		# ip->ip end
	elif [ "${type}" == "dynamic" ]
	then
		# dynamic start
		echo "[${trunkname}]"
		echo "type = aor"
		echo "max_contacts = 1"
		echo "remove_existing = yes"
		# dynamic end
	fi
	echo ""
	echo "[${trunkname}]"
	echo "type = auth"
	echo "auth_type = userpass"
	echo "username = ${trunkname}"
	echo "password = ${password}"
	echo ""
	echo "[${trunkname}]"
	echo "type = endpoint"
	echo "context = from-internal"
	echo "disallow = all"
	echo "allow = ulaw"
	if [ "${type}" == "dynamic" ]
	then
		# none: remove the 2 auth
		echo "auth = ${trunkname}"
		echo "outbound_auth = ${trunkname}"
	fi
	echo "aors = ${trunkname}"
}

# set_pjsip type trunkname username password origin_ip
set_pjsip dynamic 6666 6666 6666 172.16.8.88
