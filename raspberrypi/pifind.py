#!/usr/bin/env python2.7
import smtplib, httplib, string, subprocess
# pifind.py by Alex Eames http://RasPi.tv
# pifind.py gets the system parameters you want to know and 
# emails them through gmail to a destination of your choice

# INSTALLING pifind
# Add this line to /etc/rc.local
#   python /home/pi/pifind.py
# And place this file, pifind.py in your /home/pi folder, then
#   sudo chmod 755 /home/pi/pifind.py

# Settings
fromaddr = 'pi000001@126.com'  
toaddr  = 'pi000001@126.com'  

#mail login details
username = 'pi000001'  
password = 'p123456'  
smtp_server = 'smtp.126.com'


#get ip config info
output_if = subprocess.Popen(['ifconfig'], stdout=subprocess.PIPE).communicate()[0]

#get cpu info
output_cpu = open('/proc/cpuinfo', 'r').read()

#find cpu serial no in cpu info
keyword = "Serial"
cpu_serial = output_cpu[output_cpu.find(keyword)+ len(keyword) :]
cpu_serial = cpu_serial[cpu_serial.find(":")+ 1 :].strip()

#get external IP address
connection = httplib.HTTPConnection("checkip.dyndns.org")
connection.request('get','/')
external_ip = connection.getresponse().read()
connection.close()

#find ip address in text
keyword = "Address:"
external_ip = external_ip[external_ip.find(keyword)+ len(keyword) :]
external_ip = external_ip[:external_ip.find("<"):].strip()


BODY = string.join((
        "From: %s" % fromaddr,
        "To: %s" % toaddr,
        "Subject: Your Raspberry Pi "+cpu_serial+" just booted",
        "",
        "The CPU serial no :" + cpu_serial +"\n",
        "The external IP address:" + external_ip +"\n",
        "You may locate this IP address in http://whatismyipaddress.com \n",
        "==========================================",
        "\n\nDetailed IP info\n\n",
        output_if,
        "==========================================",
        "\n\nDetailed CPU info\n\n",
        output_cpu,
        ), "\r\n")
      
# send the email  
server = smtplib.SMTP(smtp_server)  
server.starttls()  
server.login(username,password)  
server.sendmail(fromaddr, toaddr, BODY)  
server.quit()

# emailing code from http://www.nixtutor.com/linux/send-mail-through-gmail-with-python/
# BODY bit http://www.blog.pythonlibrary.org/2010/05/14/how-to-send-email-with-python/
