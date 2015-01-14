#!/bin/bash
# Author: Michael.zou
# Date: 2014-12-18

[ "$#" != "1" ] && echo "`basename $0` config|options|log|all|-h|--help" && exit 0

case $1 in
"config") rm -rf config/* csv/* ;;
"options") rm -rf options/* ;;
"log") rm -rf error/* log/* message/* shortmessage/* ;;
"all") rm -rf config/* csv/* options/* error/* log/* message/* shortmessage/* ;;
"-h"|"--help") echo "`basename $0` config|options|log|all|-h|--help" ;;
*) ;;
esac
