#!/bin/bash
#This Script is written by Umair - http://www.NoobsLab.com
#For laptop power management (Laptop mode Tools)
#Check out another power management post (TLP) - http://www.noobslab.com/2013/07/how-to-improve-laptop-power-management.html
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+
 |N o o b s L a b . c o m|
 +-+-+-+-+-+-+-+-+-+-+-+-+
"
echo "This script is about to manage laptop power using laptop-mode-tools and other tweaks."
echo ""
echo "Do you wish to continue?"
read -p "y or n: " CONTINUEYN
if [ "$CONTINUEYN" = "y" ] || [ "$CONTINUEYN" = "yes" ] || [ "$CONTINUEYN" = "Y" ] ; then #Main if
	#Laptop mode tools
	echo "Installing laptop mode tools in your system"
	sudo apt-get install laptop-mode-tools
	echo ""
	sudo bash -c "echo 1 > /proc/sys/vm/laptop_mode"
	sleep 2
	echo ""

	USBAUTOENABLED='CONTROL_USB_AUTOSUSPEND="auto"'
	USBAUTODISABLED='CONTROL_USB_AUTOSUSPEND="0"'
	echo "Do you want to use USB devices on battery, such as USB Mouse?"
	echo "WARNING!!! It may drain your battery quickly."
	while read -p "y or n: " USBDEVICEBAT; do
		if [ "$USBDEVICEBAT" = "y" ] || [ "$USBDEVICEBAT" = "yes" ] || [ "$USBDEVICEBAT" = "Y" ] ; then #USB
			echo ""
			echo "Enabling feature to use USB devices on battery mode"
			sudo sed -i "s/$USBAUTOENABLED/$USBAUTODISABLED/g" "/etc/laptop-mode/conf.d/usb-autosuspend.conf"
			break
		elif [ "$USBDEVICEBAT" = "n" ] || [ "$USBDEVICEBAT" = "no" ] || [ "$USBDEVICEBAT" = "N" ] ; then
			echo ""
			echo "That is right decision."
			echo "But now your USB mouse/unused USB devices won't work while your laptop on battery mode."
			sudo sed -i "s/$USBAUTODISABLED/$USBAUTOENABLED/g" "/etc/laptop-mode/conf.d/usb-autosuspend.conf"
			sleep 3
			break
		else
			echo ""
			echo "Invalid Input!!!"
		fi #USB
	done

	echo ""
	echo "Restarting laptop mode service"
	sudo /etc/init.d/laptop-mode restart
	echo ""
	echo "Moving to 2nd tweak.."
	sleep 2

	#Last time directory/files access log
	echo "backing up current fstab HDD files"
	sudo cp /etc/fstab{,.backup}
	echo "Now tweaking files for HDD spin to improve battery."
	FSTABFile="noatime,nodiratime,discard,errors"
	sudo sed -i -e "s/errors/$FSTABFile/g" "/etc/fstab"
	echo ""
	echo "Moving to 3rd tweak..."
	sleep 2

	#tune Swappiness
	echo "It is about to create virtual ram"
	sudo bash -c "echo 0 > /proc/sys/vm/swappiness"
	echo ""
	echo "Moving to 4th tweak...."
	sleep 2

	#ram disk for tmp filesystem /etc/fstab
	sudo sed -i '/defaults,noatime,size=512M/d' /etc/fstab
	echo "Creating ram disk."
	sudo bash -c "echo tmpfs /tmp tmpfs defaults,noatime,size=512M,mode=1777 0 0 >> /etc/fstab"
	sudo bash -c "echo tmpfs /var/spool tmpfs defaults,noatime,size=512M,mode=1777 0 0 >> /etc/fstab"
	sudo bash -c "echo tmpfs /var/tmp tmpfs defaults,noatime,size=512M,mode=1777 0 0 >> /etc/fstab"
	echo "Do you really care about log files?"
	echo "Do you read them?"
	read -p "y or n: " LOGFILES
		if [ "$LOGFILES" = "n" ] || [ "$LOGFILES" = "NO" ] || [ "$LOGFILES" = "N" ] ; then # log files
			sudo bash -c "echo tmpfs /var/log tmpfs defaults,noatime,size=512M,mode=0755 0 0 >> /etc/fstab"
		else [ "$LOGFILES" = "y" ] || [ "$LOGFILES" = "yes" ] || [ "$LOGFILES" = "Y" ]
			echo "Ok, We are not touching logs!!!"
		fi # log files
	echo ""
	echo "Moving to 5th tweak....."
	sleep 2

	#CPU Frequency Indicator
	echo "Installing CPU Frequency indicator."
	sudo apt-get install indicator-cpufreq
	echo "Now running CPU frequency indicator"
	indicator-cpufreq& 2> /dev/null
	echo ""
	echo "All Tweaks done. Exiting script."
	sleep 3

elif [ "$CONTINUEYN" = "n" ] || [ "$CONTINUEYN" = "no" ] || [ "$CONTINUEYN" = "N" ] ; then 
	echo "Exiting script. Bye Bye"
	echo "Keep visit on NoobsLab.com"
	sleep 3
else
	echo "Invalid input!!!"
	echo "Run script again."
	sleep 3
fi #Main if
echo ""
clear
echo "Keep visit on NoobsLab.com"
cd && rm .laptop-mode.sh 2> /dev/null
