#!/usr/bin/php -q

<?php
$num = $_GET['num'];
$port = $_GET['port'];
$message = $_GET['message'];

$Begin = "----------Received Message----------";
$Message = "Received message: ".$message."\n";
$MyPhonenumber = "Phonenumber: ".$num."\n";
$MyTime = "Time: ".$time."\n";
$MyPort = "Port: ".$port."\n";

$Time = date("Y-m-d H:i:s");
$MyTime = "Time: ".$Time;
$MyStr = $Begin.$Message.$MyPhonenumber.$MyPort.$MyTime."\n";

$file_pointer = fopen("/var/www/html/message.txt", "a+");
fwrite($file_pointer, $MyStr);
fclose($file_pointer);
?>
