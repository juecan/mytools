#!/usr/bin/expect
# rm -rf /root/.ssh/known_hosts

# Login Master Board:
# Are you sure you want to continue connecting (yes/no)? 
# super@172.16.210.1's password: 
# root@Openvox-Wireless-Gateway:~# 

# Login Slave Board:
# Do you want to continue connecting? (y/n)
# super@192.168.99.2's password: 
# root@Openvox-Wireless-Gateway:~#

# Function: Login slave board to run demo_pre.sh
proc ssh_slave_board {master_ip slave_ip port user passwd} {
	# Show IP in Master Board
	expect "~#" { send "ifconfig eth0 | sed -n '2p' | awk '{print substr(\$2,1)}' | cut -d ':' -f 2\r" }

	# Login Slave Board through Master Board
	expect "${master_ip}" { send "ssh ${user}@${slave_ip} -p ${port}\r" }
	expect {
		-re "(y/n)" { send "y\r" }
		-re "password:" { send "${passwd}\r" }
	}

	# Show IP in Slave Board
	expect "~#" { send "sleep 1 && ifconfig eth0:0 | sed -n '2p' | awk '{print substr(\$2,1)}' | cut -d ':' -f 2\r" }

	# Run demo_pre.sh and exit Slave Board
	expect "~#" { send "sleep 1 && /etc/cfg/gw/demo_pre.sh\r" }
	expect "(log.c.166) server started" { send "sleep 1 && exit\r" }
}

set username "super"
set password "admin"
set port "12345"
set board_ip_1 "172.16.210.1"
#set board_ip_2 "192.168.33.215"
#set board_ip_3 "192.168.33.216"
#set board_ip_4 "192.168.33.217"
#set board_ip_5 "192.168.33.218"
set board_ip_2 "192.168.99.2"
set board_ip_3 "192.168.99.3"
#set board_ip_4 "192.168.99.4"
set board_ip_5 "192.168.99.5"

# Login Master Board
spawn ssh ${username}@${board_ip_1} -p ${port}
set timeout 300
expect {
	-re "Are you sure you want to continue connecting (yes/no)?" { send "yes\r" }
	-re "password:" { send "${password}\r" }
}

ssh_slave_board ${board_ip_1} ${board_ip_2} ${port} ${username} ${password}
ssh_slave_board ${board_ip_1} ${board_ip_3} ${port} ${username} ${password}
ssh_slave_board ${board_ip_1} ${board_ip_4} ${port} ${username} ${password}
ssh_slave_board ${board_ip_1} ${board_ip_5} ${port} ${username} ${password}

# Show IP in Master Board
expect "~#" { send "ifconfig eth0 | sed -n '2p' | awk '{print substr(\$2,1)}' | cut -d ':' -f 2\r" }
expect "${board_ip_1}" { send "sleep 1 && /etc/cfg/gw/demo_pre.sh\r" }
expect "~#" { send "exit\r" }

# Done
interact

