#! /bin/bash

# --------------------------------------------------------------------
#
#   Script converts wav or mp3 file to Asterisk compatible wav file
#   Version 0.2
#   Kolmisoft 2008
#   http://www.kolmisoft.com
#
#
#	2008.11.19  0.2	  which is removed and locations are hardcoded because 'which' is not accessible by apache user
#
# --------------------------------------------------------------------

. /usr/src/mor/test/framework/bash_functions.sh

_centos_version

sox_path="/usr/bin/sox"
lame_path="/usr/local/bin/lame"

wav_mp3()
{  _wav=`echo $1 | grep "\.wav";`
   _mp3=`echo $1 | grep "\.mp3";`

   if [ -n  "$_wav" ]; then 
        return 0;
   elif [ -n "$_mp3" ]; then 
        return 1;
   else
        return 2;
   fi
}
wav_mp3 $1; _first=$?
wav_mp3 $2; _second=$?

if [ "$_second" == 0 ]; then
    #converting to wav
    if [ "$_first" == 1 ]; then  "$lame_path" --decode $1 /tmp/tmp.wav$$; fi
    if [ "$_first" == 0 ]; then mv $1 /tmp/tmp.wav$$; fi

    _SOX=`"$sox_path" -V /tmp/tmp.wav$$ -e 2> /tmp/_sox.txt$$ && cat /tmp/_sox.txt$$ | grep 8000*  && rm -rf /tmp/_sox.txt$$`
    echo "$_SOX"
    if [ -n "$_SOX" ]; then
        if [ "$centos_version" == "5" ]; then
            "$sox_path" /tmp/tmp.wav$$ -r 8000 -c 1 -s -w $2      
        else
            "$sox_path" /tmp/tmp.wav$$ -r 8000 -c 1 -s $2      #sox provided with  centos 6 does not support -w option.
        fi

    else
        if [ "$centos_version" == "5" ]; then
            "$sox_path" /tmp/tmp.wav$$ -r 8000 -c 1 -s -w $2 resample -ql 
        else
            "$sox_path" /tmp/tmp.wav$$ -r 8000 -c 1 -s $2 resample -ql     #sox provided with  centos 6 does not support -w option.
        fi
	fi      
    chmod 777 $2       
    rm -rf /tmp/tmp.wav$$
else 
    echo "The second argument was not a wav file"; 
    exit 1;
fi
echo Finished;

