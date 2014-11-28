#!/bin/php -q
<?php
include("/etc/asterisk/agi-bin/phpagi.php");
function MatchTheCallBackListh($PhoneNum)
{
	$MyFile = fopen("/etc/asterisk/agi-bin/callbacklist.txt","r+");
	if(!$MyFile)
	{
		echo "Open the callbacklist.txt error\n";
		return 0;
	}
	while(!feof($MyFile))
	{
		$buf = fgets($MyFile);
		$gsmpos = strpos($buf,"<");
		$GSM = substr($buf,0,$gsmpos);
		$sippos = strpos($buf,">")+1;
		$SIP = substr($buf,$sippos);
		if($PhoneNum==$GSM)
		{
			return $SIP;
		}
	}
}
		
function delTargetLine($filePath, $target)
{
	$result = null;
	$fileCont = file_get_contents($filePath);
	$targetIndex = strpos($fileCont, $target);

	if ($targetIndex !== false)
	{
		$preChLineIndex = strpos(substr($fileCont, 0, $targetIndex + 1), "\n");
		$AfterChLineIndex = strpos(substr($fileCont, $targetIndex), "\n") + $targetIndex;
		if ($preChLineIndex !== false && $AfterChLineIndex !== false)
		{
			$result = substr($fileCont, 0, $preChLineIndex + 1) . substr($fileCont, $AfterChLineIndex + 1);
			$fp = fopen($filePath, "w+");
			fwrite($fp, $result);
			fclose($fp);
		}
	}
}
$agi = new AGI();
$cid = trim($agi->request['agi_callerid']);


if(($SIP=MatchTheCallBackListh($cid)))
{
	echo "SIP Extension is $SIP";
	$CallOut = "SIP/".$SIP;
	$agi->exec('Dial',$CallOut);
	$agi->hangup();
}

$listFile = "/etc/asterisk/agi-bin/callbacklist.txt";
delTargetLine($listFile, $cid);

?>
