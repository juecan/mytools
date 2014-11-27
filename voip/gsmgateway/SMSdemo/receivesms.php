<?php

echo '<center><p style="font-size:30pt;color:red;">SMS2HTTP Inbox Demo<p></center>';
@$num = $_GET['num'];
@$port = $_GET['port'];
@$message = $_GET['message'];
@$time = $_GET['time'];
$Begin = "-----------------------------------Received Message------------------------------<br>";
$Message = "Message:<br>".$message."<br>";
$MyPhonenumber = "From:".$num."<br>";
$MyPort = "Port:".$port."<br>";
$MyTime = "Time:".$time."<br>";
$MyStr = $Begin.$MyTime.$MyPhonenumber.$MyPort.$Message."<br><br>";
if(!empty($num))
{
	$file_pointer = fopen("message.txt","a+");
	fwrite($file_pointer,$MyStr);
	fclose($file_pointer);
} 
$content = file_get_contents("message.txt");
echo $content;
echo "<br>";					

?>
