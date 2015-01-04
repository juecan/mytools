#! /usr/bin/python
#  arg1 server_ip
#  arg2 ssh_username
#  arg3 ssh_pass
#  arg4 ssh_port 

import pxssh
import getpass
import sys
import mor_py_library

def klaida():
        print "Connection via pxssh failed"
        mor_py_library.log("Connection via ssh failed");            

try:                       
        s = pxssh.pxssh()
        hostname = sys.argv[1]
        username = sys.argv[2]
        password = sys.argv[3]
        port=sys.argv[4]         
        s.login (hostname, username, password,port)
        s.sendline ('ls')
        s.prompt()
        print s.before
        s.logout()
       	sys.exit(1)
        
except klaida:
        sys.exit(1)
