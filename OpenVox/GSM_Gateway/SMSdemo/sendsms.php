<?php

//http://172.16.8.188:80/sendsms?username=xxx&password=xxx&phonenumber=xxx&message=xxx&[port=xxx&][report=xxx&][timeout=xxx]

function sendSMS($ip,$phonenumber,$message)
{  
	$username = "admin";
	$password = "admin";
	//$port = "";
	//$report = "";
	//$timeout = ""; 
	//$message1 =urlencode(mb_convert_encoding($message, 'utf-8', 'gb2312'));  
	$url = "http://$ip/sendsms?username=$username&password=$password&phonenumber=$phonenumber&message=$message";  
	// echo "$url<br>";
	$link = curl_init();
	curl_setopt($link, CURLOPT_HEADER, 0);
	curl_setopt($link, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($link, CURLOPT_URL, $url);
	$response = curl_exec($link);
	curl_close($link);
	$array = json_decode($response, true);
	$report = $array['report']['0'][0][0]['result'];
	// print_r($report);

	if ($report == "success") {
		echo '<center><p style="font-size:30pt;color:red;">SMS Sent successfully!<p></center>';
	} elseif ($report == "sending") {
		echo '<center><p style="font-size:30pt;color:red;">SMS is sending, please check later!<p></center>';
	} else {
		echo '<center><p style="font-size:30pt;color:red;">SMS is failed, please check your device or settings!<p></center>';
		echo "<br>";
	}
} 

$ip = $_POST["ip"];
$phonenumber  = $_POST["phonenumber"];  
$message = $_POST["message"]; 

sendSMS($ip,$phonenumber,$message);

?>
