## Call Back 介绍

	copy those files to /etc/asterisk

	exten => h,2,AGI(/etc/asterisk/agi-bin/setcallbacklist.php,"${CDR(disposition)}" ,"${SIPROUTE:4}/${CDR(src)}","${CDR_CALLEEID}")

### setcallbacklist.php

	argv[1]: ${CDR(disposition)}
	argv[2]: ${SIPROUTE:4}/${CDR(src)}
	argv[3]: ${CDR_CALLEEID}

	${SIPROUTE}: in /etc/asterisk/sip_endpoints.conf, setvar=SIPROUTE=sip-1028-172.16.8.112

	argv[1] = "NO ANSWER"
	argv[2] = 1028-172.16.8.112/1001
	argv[3] = 13360054427
