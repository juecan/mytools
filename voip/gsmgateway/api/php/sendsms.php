#!/usr/bin/php -q
<?php

function sendsms()
{
	/* Init a curl session */
	$ch = curl_init();

	/* Setting the requestion options */
	curl_setopt($ch, CURLOPT_URL, "http://172.16.210.1:80/sendsms?username=admin&password=admin&phonenumber=10086&message=ye&port=gsm-1.2&report=String&timeout=5");

	/* Get the reply */
	$response = curl_exec($ch);

	/* Release the curl handle */
	curl_close($ch);
}

sendsms();

?>
