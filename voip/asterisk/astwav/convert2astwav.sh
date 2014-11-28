#! /bin/sh

# Kolmisoft 2009
#
# put into folder with wav files and run
# this script will convert all files to Asterisk compatible format

. /usr/src/mor/test/framework/bash_functions.sh

OUTPUT_FOLDER="converted_files"

mkdir -p $OUTPUT_FOLDER
_centos_version

for file in *; do
  echo "Converting: $file"
    if [ "$centos_version" == "5" ]; then
        /usr/bin/sox $file -r 8000 -c 1 -s -w $OUTPUT_FOLDER/$file resample -ql
    else
        /usr/bin/sox $file -r 8000 -c 1 -s $OUTPUT_FOLDER/$file resample -ql    # from centos 6 -w option is not needed as wav file has enough information in it's header.  This option was removed from new sox version provided by CentOS and causes the script not to work.
    fi
done

