#!/bin/sh

sed -i "s/onclick=\"document.getElementById('send').value='Save';return check();\" \/>/onclick=\"document.getElementById('send').value='Save';return check();\" disabled \/>/g" /www/cgi-bin/php/system-login.php

#sed -i "s/onclick=\"document.getElementById('send').value='Save';\" \/>/onclick=\"document.getElementById('send').value='Save';\" disabled \/>/g" /www/cgi-bin/php/system-general.php
#sed -i "s/onclick=\"document.getElementById('send').value='Save';\"\/>/onclick=\"document.getElementById('send').value='Save';\" disabled \/>/g" /www/cgi-bin/php/system-general.php
sed -i "s/<input type=\"checkbox\" id=\"reboot_sw\"/<input type=\"checkbox\" id=\"reboot_sw\" disabled /g" /www/cgi-bin/php/system-general.php

sed -i "s/onclick=\"document.getElementById('send').value='autocluster';\" \/>/onclick=\"document.getElementById('send').value='autocluster';\" disabled \/>/g" /www/cgi-bin/php/system-cluster.php
sed -i "s/onclick=\"document.getElementById('send').value='manualcluster';return check();\" \/>/onclick=\"document.getElementById('send').value='manualcluster';return check();\" disabled \/>/g" /www/cgi-bin/php/system-cluster.php

sed -i "s/onclick=\"document.getElementById('send').value='Save';return check();\" \/>/onclick=\"document.getElementById('send').value='Save';return check();\" disabled \/>/g" /www/cgi-bin/php/network-lan.php

sed -i "s/value=\"<?php echo language('System Reboot');?>\"/value=\"<?php echo language('System Reboot');?>\" disabled/g" /www/cgi-bin/php/system-tools.php
sed -i "s/value=\"<?php echo language('Asterisk Reboot');?>\"/value=\"<?php echo language('Asterisk Reboot');?>\" disabled/g" /www/cgi-bin/php/system-tools.php
sed -i "s/value=\"<?php echo language('System Update');?>\"/value=\"<?php echo language('System Update');?>\" disabled/g" /www/cgi-bin/php/system-tools.php
sed -i "s/value=\"<?php echo language('System Online Update');?>\"/value=\"<?php echo language('System Online Update');?>\" disabled/g" /www/cgi-bin/php/system-tools.php
sed -i "s/value=\"<?php echo language('File Upload');?>\"/value=\"<?php echo language('File Upload');?>\" disabled/g" /www/cgi-bin/php/system-tools.php
sed -i "s/value=\"<?php echo language('Download Backup');?>\"/value=\"<?php echo language('Download Backup');?>\" disabled/g" /www/cgi-bin/php/system-tools.php
sed -i "s/value=\"<?php echo language('Factory Reset');?>\"/value=\"<?php echo language('Factory Reset');?>\" disabled/g" /www/cgi-bin/php/system-tools.php
sed -i "s/input type=\"file\"/input type=\"file\" disabled/g" /www/cgi-bin/php/system-tools.php

/etc/init.d/lighttpd stop
sed "s/\"mod_auth\",/#\"mod_auth\",/g" /etc/lighttpd.conf > /tmp/lighttpd.conf
lighttpd -f /tmp/lighttpd.conf -m /usr/lib/lighttpd &

