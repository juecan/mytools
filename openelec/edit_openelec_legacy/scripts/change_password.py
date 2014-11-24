#!/usr/bin/python
# -*- coding: utf-8 -*-

# crypt a password in a format suitable for /etc/shadow (sha512)
# sha512 算法对密码进行加密
# 此脚本在 ./edit_openelec.sh before 执行后运行

import os
import crypt,getpass
import random
from optparse import OptionParser

def gensalt(length=16):
	ALPHA = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
	salt=[]
	for i in range(length):
		salt.append(random.choice(ALPHA))
	return "".join( salt )

# 6 is sha512
def shadowcrypt(password, saltlen = 16, hashalgo = 6):
	salt = gensalt()
	return crypt.crypt(password, '$%s$%s$' % (hashalgo, salt))

if __name__ == "__main__":
	# get argument, return crypt
	usage = """usage: change_password.py -p [shadow file path] -u [user in shadow file] [password]"""

	parser = OptionParser(usage=usage,version='change_password-0.1')
	parser.add_option("-p", dest = "shadowPath", help = "path to the shadow file for changing user password")
	parser.add_option("-u", dest = "shadowUser", help = "user (in shadow file) for wich the password will be changed")
	(options, args) = parser.parse_args()

	if options.shadowPath:
		shadowPath = options.shadowPath
	else:
		print usage
		exit()

	if options.shadowUser:
		shadowUser = options.shadowUser
	else:
		print usage
		exit()

	with open(shadowPath + "shadow") as infile:
		with open(shadowPath + "shadow.temp","w") as outfile:
			for line in infile:
				outfile.write(line)

	if args:
		for password in args:
			with open(shadowPath + "shadow.temp") as infile:
				with open(shadowPath + "shadow","w") as outfile:
					for line in infile:
						if line.startswith(shadowUser):
							passString = shadowUser + ":" + shadowcrypt(password) + ":::::::\n"
							outfile.write(passString)
						else:
							outfile.write(line)
	else:
		print usage

	if (os.path.exists(shadowPath + "shadow.temp")):
		os.unlink(shadowPath + "shadow.temp")
	else:
		exit()

