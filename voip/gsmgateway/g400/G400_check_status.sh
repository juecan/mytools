#!/bin/bash

# This script is a temporary solution with focus on the situation that gsm spans are running down or no signal randomly.
# It will do something to bring the span with Down status without dropping any running calls.So you have no need to worry about it. 
# It is recommended to placed this script under your crond jobs. Execute it per 30 minutes or 1 hour, just based on your needs!

#Author: Tim June <tim.june@openvox.cn>

#Time: 07/26/2013

# set-up the delay time after checking spans done in case the process of initiation of gsm spans is not ready.
DELAY=30

# check the number of spans
SPANS=`asterisk -rx "gsm show spans"|wc -l`

echo -e "########################################################################"
echo -e "########                                                         #######"
echo -e "########    There are $SPANS gsm spans need to be checked up!         #######"
echo -e "########                                                         #######"
echo -e "########################################################################"


# check the status of spans, if all spans are "UP" or "Undetected SIM Card, then exit;otherwise reset failure spans!
function  check_status()
{
	UP=`asterisk -rx "gsm show spans" 2>/dev/null |grep "Up" |wc -l`
	Undetected=`asterisk -rx "gsm show spans" 2>/dev/null |grep "Undetected" |wc -l`
        
	if [ x"$UP" = x"" ]
           then
		UP=0
	fi
		
	if [ x"$Undetected" = x"" ]
           then
		Undetected=0
	fi
		
	Total=$[ $UP + $Undetected ]
		
	if [ $Total -eq $SPANS ]
           then     
                echo -e "No available Spans are failed now!"
                exit 1
           else
                echo -e ""
                echo -e "Not all spans are UP for now, need to do something to bring them up!"
        fi
}

echo -e ""
echo -e "Begin to check spans one by one!"

# check spans at first time
check_status;

# Reset failure spans
for (( i=1; i <= $SPANS; i++ ))
do

        echo "Start to check gsm span $i:"

        STATUS=`asterisk -rx "gsm show span $i" 2>/dev/null |grep "Provisioned" | awk '{print $5}'|sed 's/,//g'`

        if [ x"$STATUS" = x"Undetected" ]
           then
                echo -e ""
                echo "The status of span $i is $STATUS SIM Card, Please check the SIM card!"
		elif [ x"$STATUS" = x"Up" ]
			then
				echo -e ""
				echo "The status of span $i is $STATUS, skip to next span!"
	else
		echo -e ""
		echo "Power Reset Span $i now ......"
		asterisk -rx "gsm power reset $i"	
        fi
done

echo -e ""
echo "All $SPANS spans have been checked out!"

# Waiting for gsm spans ready!
echo -e ""
echo -e "Wait $DELAY seconds for Ready to call!"
sleep $DELAY

echo -e "Check all gsm spans again for sure!"

# check spans again
check_status;

# Reload failure spans 
for (( i=1; i <= $SPANS; i++ ))
do

        STATUS=`asterisk -rx "gsm show span $i" 2>/dev/null |grep "Provisioned" | awk '{print $5}'|sed 's/,//g'`


        if [ x"$STATUS" != x"Up" ] && [ x"$STATUS" != x"Undetected" ]
           then
                echo -e ""
                echo "The status of span $i is still $STATUS, try to reload gsm span $i!"
                asterisk -rx "gsm reload span $i"
        fi

done

# Waiting for gsm spans ready!
echo -e ""
echo -e "Wait $DELAY seconds for Ready to call!"

sleep $DELAY


# check spans at the last time
check_status;

# Restart Asterisk when no calls running 
for (( i=1; i <= $SPANS; i++ ))
do

        STATUS=`asterisk -rx "gsm show span $i" 2>/dev/null |grep "Provisioned" | awk '{print $5}'|sed 's/,//g'`


        if [ x"$STATUS" != x"Up" ] && [ x"$STATUS" != x"Undetected" ]
        then
                echo -e "###########################################################################"
                echo -e "#####                                                               #######"
                echo -e "##### The status of span $i is still $STATUS, I am afraid Asterisk  #######"
                echo -e "##### needs to be restarted to bring Span $i UP! Asterisk will be  #######"
                echo -e "##### restarted after all calls are finished!                       #######"
                echo -e "#####                                                               #######"
                echo -e "###########################################################################"


                asterisk -rx "core restart gracefully"
        fi

done
