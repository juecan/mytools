#!/bin/php -q
<?php
function strToHex($string)
{
    $hex='';
    for ($i=0; $i < strlen($string); $i++)
    {
        $hex .= dechex(ord($string[$i]));
    }
    return $hex;
}
function hexToStr($hex)
{
    $string='';
    for ($i=0; $i < strlen($hex)-1; $i+=2)
    {
        $string .= chr(hexdec($hex[$i].$hex[$i+1]));
    }
    return $string;
}

function hexbin($hex){
    $bin='';
    for($i=0;$i<strlen($hex);$i++)
        $bin.=str_pad(decbin(hexdec($hex{$i})),4,'0',STR_PAD_LEFT);
       return $bin;
} 

function binhex($bin){
    $hex='';
    for($i=strlen($bin)-4;$i>=0;$i-=4)
        $hex.=dechex(bindec(substr($bin,$i,4)));
   return strrev($hex);
}

function Convert8BitTo7Bit($string){
	// Convert String to Hex first
	// E.g *135# will be converted to 2A 31 33 35 23
	$string = strToHex($string);
	// print   "STR = $string\n";
	$total = "";
	for($i = 0; $i < strlen($string); ){
		// Get 1st character string, it's 2 character hex
		$X = $string[$i++].$string[$i++];
		// Convert it to binary
		$my8bit = hexbin($X);
		//print "(8bit) ==> $my8bit\n";
		// remove left side of octet, it shall be septet
		// e.g 2A in octet is 00101010 (8 bit), remove most left 0 --> 0101010 (7 bit)
		$my7bit = substr($my8bit,1,7);
		//print "(7bit) ==>  $my7bit\n";
        // Concatenate it
		$total = $my7bit.$total;
	}
	// Padding the string
	if(strlen($total) % 8 != 0){
		$p1     = (intval((strlen($total) / 8)) + 1) *  8;
		$total  = str_pad($total,$p1,'0',STR_PAD_LEFT);
	}
	$pad   = 7;
	// Conversion begin
	for($i = strlen($total) - 1; $i >= 0 ; $i--){
		$mypad[$pad--] = $total[$i];
		if($pad < 0 || $i <= 0){
			$pad  = 7;
			$tmp1 = array_reverse($mypad);
			//print_r($tmp1);
			$tmp2 = implode($tmp1);
			$res = binhex($tmp2);
			$result .= "$res";
		}
	}
	return $result;
}

print Convert8BitTo7Bit("*113#")."\n";

?>