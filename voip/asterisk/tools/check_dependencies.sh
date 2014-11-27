# !/bin/bash
#
# install.sh - OpenVox Installation Script for G400P
#
#
# Copyright (C) 2005-2012 OpenVox Communication Co. Ltd,
# All rights reserved.
#
# $Id$
#
# This program is free software, distributed under the terms of
# the GNU General Public License Version 2 as published by the
# Free Software Foundation. See the LICENSE file included with
# this program for more details.
# 

# ----------------------------------------------------------------------------
# Clear the screen if it is supported.
# ----------------------------------------------------------------------------
clearscr()
{
	if [ $SETUP_INSTALL_QUICK = "YES" ]; then
		return
	fi

	if test $NONINTERACTIVE; then
		return
	fi

	# check if the terminal environment is set up
	[ "$TERM" ] && clear 2> /dev/null
}


# ----------------------------------------------------------------------------
# check bash
# ----------------------------------------------------------------------------
check_bash ()
{
	BASH_SUPPORT=`echo $BASH_VERSION | cut -d'.' -f1 2> /dev/null`
	test -z $BASH_SUPPORT && echo "Bash not existed!" && exit 1
}


# ----------------------------------------------------------------------------
# Display banner
# ----------------------------------------------------------------------------
banner()
{
	if test -z $NONINTERACTIVE; then
		clearscr
	fi
	
	echo -e "########################################################################"
	echo -e "#                   OpenVox Installation Script                        #"
	echo -e "#                          check_dependencies                          #"
	echo -e "#                     OpenVox Communication Co.,Ltd                    #"
	echo -e "#        Copyright (c) 2009-2012 OpenVox. All Rights Reserved.         #"
	echo -e "########################################################################"	
	echo ""
	
	return 0
}


# ----------------------------------------------------------------------------
# Save logger info
# ----------------------------------------------------------------------------
logger()
{
	if [ "$2" == "0" ]; then
		:
	else
		echo -ne "$1"
	fi
	if [ "$LOG_ENABLE" == "YES" ]; then
		if [ "$3" == "0" ]; then
			:
		else
			echo -ne "$(LANG=C date) : $1" >> "$INSTALL_LOG"
		fi
	fi
}


# ----------------------------------------------------------------------------
# Display error message.
# ----------------------------------------------------------------------------
error()
{
	echo -ne "Error: $*" >&2

	if [ "$LOG_ENABLE" == "YES" ]; then
		echo -ne "$(LANG=C date) : Error: $*" >> "$INSTALL_LOG"
	fi
}


# ----------------------------------------------------------------------------
# Pause.
# ----------------------------------------------------------------------------
pause()
{
	[ $# -ne 0 ] && sleep $1 >&2 >> /dev/null && return 0
	echo -e "Press [Enter] to continue...\c"
	read tmp
	
	return 0
}

# ----------------------------------------------------------------------------
# Prompt user for input.
# ----------------------------------------------------------------------------
prompt()
{
	if test $NONINTERACTIVE; then
		return 0
	fi

	echo -ne "$*" >&2
	read CMD rest
	return 0
}

# ----------------------------------------------------------------------------
# Get Yes/No
# ----------------------------------------------------------------------------
getyn()
{
	if test $NONINTERACTIVE; then
		return 0
	fi

	while prompt "$* (y/n) "
	do	case $CMD in
			[yY])	return 0
				;;
			[nN])	return 1
				;;
			*)	echo -e "\nPlease answer y or n" >&2
				;;
		esac
	done
}

# ----------------------------------------------------------------------------
# Select an item from the list.
# $SEL: the available chooice
# Return:	0 - selection is in $SEL
#		    1 - quit or empty list
# ----------------------------------------------------------------------------

show_status()
{
	if [ "$LOG_ENABLE" == "YES" ]; then
		echo "" >> "$INSTALL_LOG"
		echo -ne "$(LANG=C date) : \t\t\t\t\t\t[ $1 ]\n" >> "$INSTALL_LOG"
	fi
	logger "\r\t\t\t\t\t\t\t\t[ $1 ]\n" 1 0
}


error_compile()
{
	echo
	tail -n 50 "$INSTALL_LOG"
	echo "==========================================================================="
	logger "$1"
	show_status Failure
	echo "==========================================================================="
	exit 1
}


backup_file()
{
	\cp -a "$1" "$1.$(date +%F-%k-%M)"
	if [ $? -ne 0 ]; then
		return 1
	fi
}


redhat_check_dependencies()
{
	missing_packages=" "
	logger "Checking for C development tools ..."
	eval "rpm -q gcc > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "gcc --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gcc "
		fi
	fi
		
	logger "Checking for C++ developement tools ..."
	eval "rpm -q gcc-c++ > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else	
		eval "g++ --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gcc-c++ "
		fi
	fi
	
	logger "Checking for Make utility ..."
	eval "rpm -q make > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "make --version > /dev/null 2>&1"	
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"make "
		fi
	fi
	
	logger "Checking for ncurses library ... "
	eval "rpm -q ncurses > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type clear > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"ncurses "
		fi
	fi
	
	logger "Checking for ncurses-devel library ... "
	eval "rpm -q ncurses-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ ! -f "/usr/include/ncurses.h" ] && [ ! -f "/usr/include/ncurses/ncurses.h" ]; then
			show_status	FAILURE
			missing_packages=$missing_packages"ncurses-devel "
		else
			show_status	OK
		fi
	fi
	
	logger "Checking for Perl developement tools ..."
	eval "rpm -q perl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "perl --version >/dev/null > 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"perl "
		fi
	fi
	
	logger "Checking for Patch ..."
	eval "rpm -q patch > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "patch --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"patch "
		fi
	fi
	
	logger "Checking for bison..."
	eval "rpm -q bison > /dev/null"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type bison > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"bison "
		fi
	fi
	
	logger "Checking for bison-devel..."
	eval "rpm -q bison-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [  -f /usr/lib/liby.a ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"bison-devel "
		fi
	fi
	
	logger "Checking for openssl..."
	eval "rpm -q openssl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type openssl > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"openssl "
		fi
	fi
	
	logger "Checking for openssl-devel..."
	eval "rpm -q openssl-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/openssl/ssl.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"openssl-devel "
		fi
	fi
	
	logger "Checking for gnutls-devel..."
	eval "rpm -q gnutls-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/gnutls/gnutls.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gnutls-devel "
		fi
	fi

	logger "Checking for zlib..."
	eval "rpm -q zlib > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/lib/libz.so.1 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib "
		fi
	fi

	logger "Checking for zlib-devel..."
	eval "rpm -q zlib-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/zlib.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib-devel "
		fi
	fi

	logger "Checking for kernel development packages..."
	eval "rpm -q kernel-devel-$(uname -r) > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"kernel-devel-$(uname -r) "
	fi
	
	logger "Checking for libxml2-devel..."
	eval "rpm -q libxml2-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"libxml2-devel "
	fi

	logger "Checking for wget..."
	eval "rpm -q wget > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"wget "
	fi
	
	echo
	if [  "$missing_packages" !=  " " ]; then
		echo "WARNING: You are missing some prerequisites"
		logger "Missing Packages $missing_packages\n"
		for package in $missing_packages
		do
			case $package in
				gcc)
					echo -e "\n C Compiler (gcc)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc package (e.g yum install gcc)."
				;;
				g++)
					echo -e "\n C++ Compiler (g++)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc-c++ package (e.g yum install gcc-c++)."
				;;
				make)
					echo -e "\n make utility."
					echo -e "    Required for compiling packages."
					echo -e "    Install make package (e.g yum install make)."
				;;
				bash)
					echo -e "\n Bash v2 or greater."
					echo -e "    Required for installation and configuration scripts."
				;;
				ncurses)
					echo -e "\n ncurses library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g yum install ncurses)."
				;;
				ncurses-devel)
					echo -e "\n ncurses-devel library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g yum install ncurses-devel)."
				;;
				perl)
					echo -e "\n Perl development tools."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses Perl package (e.g yum install perl)."
				;;
				patch)
					echo -e "\n Patch ."
					echo -e "    Required for compiling packages."
					echo -e "    Install Patch package (e.g yum install patch)."
				;;
				bison)
					echo -e "\n Bison."
					echo -e "    Required for compiling packages."
					echo -e "    Install bison package (e.g yum install bison)."
				;;
				bison-devel)
					echo -e "\n Bison library."
					echo -e "    Required for compiling packages."
					echo -e "    Install bison-devel package (e.g yum install bison-devel)."
				;;
				openssl)
					echo -e "\n OpenSSL."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl package (e.g yum install openssl)."
				;;
				openssl-devel)
					echo -e "\n OpenSSL library."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl-devel package (e.g yum install openssl-devel)."
				;;
				gnutls-devel)
					echo -e "\n Gnutls library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g yum install gnutls-devel)."
				;;
				zlib)
					echo -e "\n Zlib library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g yum install zlib)."
				;;
				zlib-devel)
					echo -e "\n Zlib development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install zlib-devel package (e.g yum install zlib-devel)."
				;;
				kernel-devel-$(uname -r))
					echo -e "\n Kernel development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install kernel-devel-$(uname -r) package (e.g yum install kernel-devel-$(uname -r))."
				;;
				libxml2-devel)
					echo -e "\n libxml2 development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install libxml2-devel package (e.g yum install libxml2-devel)."
				;;
				wget)
					echo -e "\n wget tools."
					echo -e "    Required for compiling packages."
					echo -e "    Install wget package (e.g yum install wget)."
				;;

			esac
		done

		echo
		getyn "Would you like to install the missing packages"
		if [ $? -eq 0 ]; then
			for package in $missing_packages
			do
				echo "yum install -y $package"
				yum install -y $package
			done
		fi
	fi

	#Freedom del 2012-10-12 10:01 
	#pause
	
	return 0
}


suse_check_dependencies()
{
	missing_packages=" "
	logger "Checking for C development tools ..."
	eval "rpm -q gcc > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "gcc --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gcc "
		fi
	fi
		
	logger "Checking for C++ developement tools ..."
	eval "rpm -q gcc-c++ > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "g++ --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gcc-c++ "
		fi
	fi
	
	logger "Checking for Make utility ..."
	eval "rpm -q make > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "make --version > /dev/null 2>&1"	
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"make "
		fi
	fi
	
	logger "Checking for ncurses library ... "
	eval "rpm -q ncurses > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type clear > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"ncurses "
		fi
	fi
	
	logger "Checking for ncurses-devel library ... "
	eval "rpm -q ncurses-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ ! -f "/usr/include/ncurses.h" ] && [ ! -f "/usr/include/ncurses/ncurses.h" ]; then
			show_status	FAILURE
			missing_packages=$missing_packages"ncurses-devel "
		else
			show_status	OK
		fi
	fi
	
	logger "Checking for Perl developement tools ..."
	eval "rpm -q perl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "perl --version >/dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"perl "
		fi
	fi
	
	logger "Checking for Patch ..."
	eval "rpm -q patch > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "patch --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"patch "
		fi
	fi
	
	logger "Checking for bison..."
	eval "rpm -q bison > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type bison > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"bison "
		fi
	fi
	
	logger "Checking for bison-devel..."
	eval "rpm -q bison-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [  -f /usr/lib/liby.a ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"bison-devel "
		fi
	fi
	
	logger "Checking for openssl..."
	eval "rpm -q openssl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type openssl > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"openssl "
		fi
	fi
	
	logger "Checking for openssl-devel..."
	eval "rpm -q openssl-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/openssl/ssl.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"openssl-devel "
		fi
	fi
	
	logger "Checking for gnutls-devel..."
	eval "rpm -q gnutls-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/gnutls/gnutls.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gnutls-devel "
		fi
	fi

	logger "Checking for zlib..."
	eval "rpm -q zlib > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/lib/libz.so.1 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib "
		fi
	fi

	logger "Checking for zlib-devel..."
	eval "rpm -q zlib-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/zlib.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib-devel "
		fi
	fi

	logger "Checking for kernel development packages..."
	eval "rpm -q kernel-devel-$(uname -r) > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"kernel-devel-$(uname -r) "
	fi
	
	logger "Checking for libxml2-devel..."
	eval "rpm -q libxml2-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"libxml2-devel "
	fi
	
	echo
	if [  "$missing_packages" !=  " " ]; then
		echo "WARNING: You are missing some prerequisites"
		logger "Missing Packages $missing_packages\n"
		for package in $missing_packages
		do
			case $package in
				gcc)
					echo -e "\n C Compiler (gcc)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc package (e.g zypper install gcc)."
				;;
				g++)
					echo -e "\n C++ Compiler (g++)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc-c++ package (e.g zypper install gcc-c++)."
				;;
				make)
					echo -e "\n make utility."
					echo -e "    Required for compiling packages."
					echo -e "    Install make package (e.g zypper install make)."
				;;
				bash)
					echo -e "\n Bash v2 or greater."
					echo -e "    Required for installation and configuration scripts."
				;;
				ncurses)
					echo -e "\n ncurses library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g zypper install ncurses)."
				;;
				ncurses-devel)
					echo -e "\n ncurses-devel library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g zypper install ncurses-devel)."
				;;
				perl)
					echo -e "\n Perl development tools."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses Perl package (e.g zypper install perl)."
				;;
				patch)
					echo -e "\n Patch ."
					echo -e "    Required for compiling packages."
					echo -e "    Install Patch package (e.g zypper install patch)."
				;;
				bison)
					echo -e "\n Bison."
					echo -e "    Required for compiling packages."
					echo -e "    Install bison package (e.g zypper install bison)."
				;;
				bison-devel)
					echo -e "\n Bison library."
					echo -e "    Required for compiling packages."
					echo -e "    Install bison-devel package (e.g zypper install bison-devel)."
				;;
				openssl)
					echo -e "\n OpenSSL."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl package (e.g zypper install openssl)."
				;;
				openssl-devel)
					echo -e "\n OpenSSL library."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl-devel package (e.g zypper install openssl-devel)."
				;;
				gnutls-devel)
					echo -e "\n Gnutls library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g zypper install gnutls-devel)."
				;;
				zlib)
					echo -e "\n Zlib library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g zypper install zlib)."
				;;
				zlib-devel)
					echo -e "\n Zlib development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install zlib-devel package (e.g zypper install zlib-devel)."
				;;
				kernel-devel-$(uname -r))
					echo -e "\n Kernel development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install kernel-devel-$(uname -r) package (e.g zypper install kernel-devel-$(uname -r))."
				;;
				libxml2-devel)
					echo -e "\n libxml2 development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install libxml2-devel package (e.g yum zypper libxml2-devel)."
				;;

			esac
		done

		echo
		getyn "Would you like to install the missing packages"
		if [ $? -eq 0 ]; then
			for package in $missing_packages
			do
				echo "zypper install -y $package"
				zypper install -y $package
			done
		fi
	fi

	#Freedom del 2012-10-12 10:01 
	#pause
	
	return 0
}


debian_check_dependencies()
{
	missing_packages=" "
	logger "Checking for C development tools ..."
	eval "dpkg-query -s gcc > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "gcc --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gcc "
		fi
	fi
		
	logger "Checking for C++ developement tools ..."
	eval "dpkg-query -s g++ > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else	
		eval "g++ --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"g++ "
		fi
	fi
	
	logger "Checking for Make utility ..."
	eval "dpkg-query -s make > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "make --version > /dev/null 2>&1"	
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"make "
		fi
	fi
	
	logger "Checking for ncurses library ... "
	eval "dpkg-query -s ncurses > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type clear > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"ncurses "
		fi
	fi
	
	logger "Checking for libncurses-dev library ... "
	eval "dpkg-query -s libncurses-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ ! -f "/usr/include/ncurses.h" ] && [ ! -f "/usr/include/ncurses/ncurses.h" ]; then
			show_status	FAILURE
			missing_packages=$missing_packages"libncurses-dev "
		else
			show_status	OK
		fi
	fi
	
	logger "Checking for Perl developement tools ..."
	eval "dpkg-query -s perl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "perl --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"perl "
		fi
	fi
	
	logger "Checking for Patch ..."
	eval "dpkg-query -s patch > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "patch --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"patch "
		fi
	fi
	
	logger "Checking for bison..."
	eval "dpkg-query -s bison > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type bison > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"bison "
		fi
	fi
	
	logger "Checking for bison-devel..."
	eval "dpkg-query -s bison-devel > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [  -f /usr/lib/liby.a ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"bison-devel "
		fi
	fi
	
	logger "Checking for openssl..."
	eval "dpkg-query -s openssl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type openssl > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"openssl "
		fi
	fi
	
	logger "Checking for libssl-dev..."
	eval "dpkg-query -s libssl-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/openssl/ssl.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"libssl-dev "
		fi
	fi
	
	logger "Checking for libgnutls-dev..."
	eval "dpkg-query -s libgnutls-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/gnutls/gnutls.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"libgnutls-dev "
		fi
	fi

	logger "Checking for zlib1g..."
	eval "dpkg-query -s zlib1g > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/lib/libz.so.1 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib1g "
		fi
	fi

	logger "Checking for zlib1g-dev..."
	eval "dpkg-query -s zlib1g-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/zlib.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib1g-dev "
		fi
	fi

	logger "Checking for kernel development packages..."
	eval "dpkg-query -s linux-headers-$(uname -r) > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"linux-headers-$(uname -r) "
	fi
	
	logger "Checking for libxml2-dev..."
	eval "dpkg-query -s libxml2-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"libxml2-dev "
	fi
	
	echo
	if [  "$missing_packages" !=  " " ]; then
		echo "WARNING: You are missing some prerequisites"
		logger "Missing Packages $missing_packages\n"
		for package in $missing_packages
		do
			case $package in
				gcc)
					echo -e "\n C Compiler (gcc)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc package (e.g apt-get install gcc)."
				;;
				g++)
					echo -e "\n C++ Compiler (g++)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc-c++ package (e.g apt-get install gcc-c++)."
				;;
				make)
					echo -e "\n make utility."
					echo -e "    Required for compiling packages."
					echo -e "    Install make package (e.g apt-get install make)."
				;;
				bash)
					echo -e "\n Bash v2 or greater."
					echo -e "    Required for installation and configuration scripts."
				;;
				ncurses)
					echo -e "\n ncurses library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g apt-get install ncurses)."
				;;
				libncurses-dev)
					echo -e "\n libncurses-dev library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g apt-get install libncurses-dev)."
				;;
				perl)
					echo -e "\n Perl development tools."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses Perl package (e.g apt-get install perl)."
				;;
				patch)
					echo -e "\n Patch ."
					echo -e "    Required for compiling packages."
					echo -e "    Install Patch package (e.g apt-get install patch)."
				;;
				bison)
					echo -e "\n Bison."
					echo -e "    Required for compiling packages."
					echo -e "    Install bison package (e.g apt-get install bison)."
				;;
				bison-devel)
					echo -e "\n Bison library."
					echo -e "    Required for compiling packages."
					echo -e "    Install bison-devel package (e.g apt-get install bison-devel)."
				;;
				openssl)
					echo -e "\n OpenSSL."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl package (e.g apt-get install openssl)."
				;;
				libssl-dev)
					echo -e "\n OpenSSL library."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl-devel package (e.g apt-get install libssl-dev)."
				;;
				libgnutls-dev)
					echo -e "\n Gnutls library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g apt-get install libgnutls-dev)."
				;;
				zlib1g)
					echo -e "\n Zlib1g library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g apt-get install zlib1g)."
				;;
				zlib1g-dev)
					echo -e "\n Zlib development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install zlib-devel package (e.g apt-get install zlib1g-dev)."
				;;
				linux-headers-$(uname -r))
					echo -e "\n Kernel development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install kernel-devel-$(uname -r) package (e.g apt-get install linux-headers-$(uname -r))."
				;;
				libxml2-dev)
					echo -e "\n libxml2 development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install libxml2-devel package (e.g apt-get install libxml2-dev)."
				;;

			esac
		done

		echo
		getyn "Would you like to install the missing packages"
		if [ $? -eq 0 ]; then
			for package in $missing_packages
			do
				echo "apt-get install -y $package"
				apt-get install -y $package
			done
		fi
	fi

	#Freedom del 2012-10-12 10:01 
	#pause
	
	return 0
}


ubuntu_check_dependencies()
{
	missing_packages=" "
	logger "Checking for C development tools ..."
	eval "dpkg-query -s gcc > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "gcc --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"gcc "
		fi
	fi
		
	logger "Checking for C++ developement tools ..."
	eval "dpkg-query -s g++ > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else	
		eval "g++ --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"g++ "
		fi
	fi
	
	logger "Checking for Make utility ..."
	eval "dpkg-query -s make > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "make --version > /dev/null 2>&1"	
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"make "
		fi
	fi
	
	logger "Checking for ncurses library ... "
	eval "dpkg-query -s ncurses > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type clear > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"ncurses "
		fi
	fi
	
	logger "Checking for libncurses5-dev library ... "
	eval "dpkg-query -s libncurses5-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ ! -f "/usr/include/ncurses.h" ] && [ ! -f "/usr/include/ncurses/ncurses.h" ]; then
			show_status	FAILURE
			missing_packages=$missing_packages"libncurses5-dev "
		else
			show_status	OK
		fi
	fi
	
	logger "Checking for Perl developement tools ..."
	eval "dpkg-query -s perl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "perl --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"perl "
		fi
	fi
	
	logger "Checking for Patch ..."
	eval "dpkg-query -s patch > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "patch --version > /dev/null 2>&1"
		if [ $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"patch "
		fi
	fi
	
	logger "Checking for bison..."
	eval "dpkg-query -s bison > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type bison > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"bison "
		fi
	fi
	
	logger "Checking for openssl..."
	eval "dpkg-query -s openssl > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		eval "type openssl > /dev/null 2>&1"
		if [  $? -eq 0 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"openssl "
		fi
	fi
	
	logger "Checking for libssl-dev..."
	eval "dpkg-query -s libssl-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/openssl/ssl.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"libssl-dev "
		fi
	fi
	
	logger "Checking for libgnutls-dev..."
	eval "dpkg-query -s libgnutls-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/gnutls/gnutls.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"libgnutls-dev "
		fi
	fi

	logger "Checking for zlib1g..."
	eval "dpkg-query -s zlib1g > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/lib/libz.so.1 ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib1g "
		fi
	fi

	logger "Checking for zlib1g-dev..."
	eval "dpkg-query -s zlib1g-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		if [ -f /usr/include/zlib.h ]; then
			show_status	OK
		else
			show_status	FAILURE
			missing_packages=$missing_packages"zlib1g-dev "
		fi
	fi

	logger "Checking for kernel development packages..."
	eval "dpkg-query -s linux-headers-$(uname -r) > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"linux-headers-$(uname -r) "
	fi
	
	logger "Checking for libxml2-dev..."
	eval "dpkg-query -s libxml2-dev > /dev/null 2>&1"
	if [ $? -eq 0 ]; then
		show_status	OK
	else
		show_status	FAILURE
		missing_packages=$missing_packages"libxml2-dev "
	fi
	
	echo
	if [  "$missing_packages" !=  " " ]; then
		echo "WARNING: You are missing some prerequisites"
		logger "Missing Packages $missing_packages\n"
		for package in $missing_packages
		do
			case $package in
				gcc)
					echo -e "\n C Compiler (gcc)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc package (e.g apt-get install gcc)."
				;;
				g++)
					echo -e "\n C++ Compiler (g++)."
					echo -e "    Required for compiling packages."
					echo -e "    Install gcc-c++ package (e.g apt-get install gcc-c++)."
				;;
				make)
					echo -e "\n make utility."
					echo -e "    Required for compiling packages."
					echo -e "    Install make package (e.g apt-get install make)."
				;;
				bash)
					echo -e "\n Bash v2 or greater."
					echo -e "    Required for installation and configuration scripts."
				;;
				ncurses)
					echo -e "\n ncurses library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g apt-get install ncurses)."
				;;
				libncurses5-dev)
					echo -e "\n libncurses5 library."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses development package (e.g apt-get install libncurses5-dev)."
				;;
				perl)
					echo -e "\n Perl development tools."
					echo -e "    Required for compiling packages."
					echo -e "    Install ncurses Perl package (e.g apt-get install perl)."
				;;
				patch)
					echo -e "\n Patch ."
					echo -e "    Required for compiling packages."
					echo -e "    Install Patch package (e.g apt-get install patch)."
				;;
				bison)
					echo -e "\n Bison."
					echo -e "    Required for compiling packages."
					echo -e "    Install bison package (e.g apt-get install bison)."
				;;
				openssl)
					echo -e "\n OpenSSL."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl package (e.g apt-get install openssl)."
				;;
				libssl-dev)
					echo -e "\n OpenSSL library."
					echo -e "    Required for compiling packages."
					echo -e "    Install openssl-devel package (e.g apt-get install libssl-dev)."
				;;
				libgnutls-dev)
					echo -e "\n Gnutls library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g apt-get install libgnutls-dev)."
				;;
				zlib1g)
					echo -e "\n Zlib1g library."
					echo -e "    Required for compiling packages."
					echo -e "    Install gnutls-devel package (e.g apt-get install zlib1g)."
				;;
				zlib1g-dev)
					echo -e "\n Zlib development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install zlib-devel package (e.g apt-get install zlib1g-dev)."
				;;
				linux-headers-$(uname -r))
					echo -e "\n Kernel development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install kernel-devel-$(uname -r) package (e.g apt-get install linux-headers-$(uname -r))."
				;;
				libxml2-dev)
					echo -e "\n libxml2 development packages."
					echo -e "    Required for compiling packages."
					echo -e "    Install libxml2-devel package (e.g apt-get install libxml2-dev)."
				;;

			esac
		done

		echo
		getyn "Would you like to install the missing packages"
		if [ $? -eq 0 ]; then
			for package in $missing_packages
			do
				echo "apt-get install -y $package"
				apt-get install -y $package
			done
		fi
	fi

	#Freedom del 2012-10-12 10:01 
	#pause
	
	return 0
}


#  Freedom add 2011-12-16 17:40
##############################################################################
OS="redhat"
check_os()
{
	cat /proc/version | grep 'Red Hat' > /dev/null
	if [ $? -eq 0 ]; then
		OS="redhat"
		return
	fi

	cat /proc/version | grep 'SUSE' > /dev/null
	if [ $? -eq 0 ]; then
		OS="suse"
		return
	fi

	cat /proc/version | grep 'Debian' > /dev/null
	if [ $? -eq 0 ]; then
		OS="debian"
		return
	fi

	cat /proc/version | grep 'Ubuntu' > /dev/null
	if [ $? -eq 0 ]; then
		OS="ubuntu"
		return
	fi
}

# Freedom add 2011-12-16 17:40
##############################################################################
# Check OS
if [ x"$OPT_NC" != x"true" ]; then
	check_os
fi
##############################################################################

# show banner
banner

# check bash version
check_bash

# check dependences
if [ x"$OPT_NC" != x"true" ]; then
	if [ x"$OS" = x"redhat" ]; then
		redhat_check_dependencies
	elif [ x"$OS" = x"suse" ]; then
		suse_check_dependencies
	elif [ x"$OS" = x"debian" ]; then
		debian_check_dependencies
	elif [ x"$OS" = x"ubuntu" ]; then
		ubuntu_check_dependencies
	else
		redhat_check_dependencies
	fi
fi

# show banner
banner
