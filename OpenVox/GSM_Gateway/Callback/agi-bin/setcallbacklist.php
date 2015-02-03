#!/bin/php -q
<?php		
include("/etc/asterisk/agi-bin/phpagi.php");

function WriteTheCallBackList($GSM,$SIP)
{
	$MyFile = fopen("/etc/asterisk/agi-bin/callbacklist.txt","a");
	if(!$MyFile) {
		echo "Open the callbacklist.txt error\n";
		return 0;
	}
	$List = $GSM."<--------->".$SIP;
	fwrite($MyFile,$List);
	fwrite($MyFile,"\n");
	fclose($MyFile);
}
$agi = new AGI();
if($argv[1]=="NO ANSWER")
{
	WriteTheCallBackList($argv[3],$argv[2]);
}
?>
