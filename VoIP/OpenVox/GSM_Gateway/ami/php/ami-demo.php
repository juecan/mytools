#!/usr/bin/php -q

<?php
	//include("phpagi-2.20/phpagi-asmanager.php");

	fwrite(STDOUT, "Enter your Server IP: "); 
	$serverIP = trim(fgets(STDIN));
	fwrite(STDOUT, "port: ");
	$port = trim(fgets(STDIN));
	fwrite(STDOUT, "command: ");
	$command = trim(fgets(STDIN));
/*
	$serverIP = "172.16.8.186";
	$port = 5038;
	$command = "gsm show spans";
*/
	$socket = fsockopen($serverIP, 5038);
	if(!$socket) {
		echo "Unable to open socket!\n";
	} else {
		fwrite($socket, "Action: Login\r\n");
		fwrite($socket, "username: admin\r\n");
		fwrite($socket, "secret: admin\r\n\r\n");
		$wrets = fgets($socket, 128);
		echo $wrets;

		sleep(1);
		fwrite($socket, "Action: Command\r\n");
		fwrite($socket, "command: " . $command . "\r\n\r\n");
		while($c = fread($socket, 2046)) {
			echo $c;
			if($c == "--END COMMAND--\r\n\r\n") {
				break;
			}
		}
		fwrite($socket, "Action: Logoff\r\n\r\n");
	}
?>
