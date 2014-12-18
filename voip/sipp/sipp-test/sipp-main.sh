#!/bin/bash
# Author: Michael.zou
# Date: 2014-12-18

[ "$#" != "1" ] && echo "`basename $0` filename" && exit 0
filename=$1

. function/sipp-function

[ ! -f "config/${filename}.conf" ] && config_sipp_options ${filename}
[ ! -f "csv/${filename}.csv" ] && general_csv_file ${filename}
general_sipp_options ${filename}

