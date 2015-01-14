#!/bin/bash

VERSION=0.0.1
ORIG_DIR=/storage/system.orig
NEW_DIR=/storage/system.new

. config/copy_system
. config/pack_system
. config/change_passwd
. config/help_info

if [ $# != 1 ]
then
	echo "You need one parameter!"
	echo "Usage: $0 first|passwd|end|--help|-h|--version"
	exit
fi

case $1 in
"first")
	copy_system ${ORIG_DIR} ${NEW_DIR}
	;;
"end")
	pack_system ${NEW_DIR}
	;;
"passwd")
	change_passwd ${NEW_DIR}
	;;
"--version")
	echo "$0 version: ${VERSION}"
	;;
"-h")
	echo "Usage: $0 first|passwd|end|--help|-h|--version"
	;;
"--help")
	help_info $0 ${NEW_DIR}
	;;
*)
	echo "Error: Invalid parameter!"
	echo "Usage: $0 first|passwd|end|--help|-h|--version"
	;;
esac

