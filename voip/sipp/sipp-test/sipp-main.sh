#!/bin/bash
# Author: Michael.zou
# Date: 2014-12-18

[ "$#" != "1" ] && echo "`basename $0` filename" && exit 0
filename=$1

. function/sipp-function

[ ! -f "config/${filename}.conf" ] && config_sipp_options ${filename}
if [ ! -f "csv/${filename}.csv" ]
then
	general_csv_file ${filename}
elif [ "config/${filename}.conf" -nt "csv/${filename}.csv" ]
then
	general_csv_file ${filename}
fi
options=$(general_sipp_options ${filename})
sipp ${options}
#echo ${options}
