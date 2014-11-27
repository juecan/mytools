#!/bin/bash
# CentOS7 设置 httpd，使用 IP 访问，需要开启防火墙

iptables -I INPUT -p TCP --dport 80 -j ACCEPT
