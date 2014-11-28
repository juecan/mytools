#! /bin/sh

# Kolmisoft 2009
#
# put into folder with wav files and run
# this script will convert all wav files to MP3 format
# original WAV files will not be deleted for backup


for file in *; do
  echo "Converting: $file"
 
    name=${file%\.*}
    echo ${name} 

    /usr/local/bin/lame --resample 44.1 -b 32 -a ${name}.wav ${name}.mp3
  
#  /usr/bin/sox $file -r 8000 -c 1 -s -w $file resample -ql
  
done