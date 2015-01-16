#!/bin/sh

/my_tools/add_syslog "Switch filesystem"

/usr/bin/auto_update -s

reboot
