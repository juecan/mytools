
## OpenVox GSM Gateway SMS Demo

### 注意

	SMS - SMS Settings - HTTP to SMS:
		Enable ON, Advanced ON, Debug 1

	SMS - SMS Settings - SMS to HTTP:
		Enable ON
		URL: http://172.16.8.88:80/SMSdemo_mine/receivesms.php?num=phonenumber&port=port&message=message&time=time
		chmod 777 /var/www/html/SMSdemo_mine/receivesms.php
		chmod 666 /var/www/html/SMSdemo_mine/message.txt
