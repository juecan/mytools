## pptp

### CentOS 7 Setup PPTP VPN

	安装：install ppp/pptp/pptp-setup
	建立 VPN：pptpsetup --create OpenVox_VPN --server 106.185.43.194 --username support08 --password nR3HgN5WL6S969Qq
	查看连接信息：vim /var/log/messages

### 使用

	开启：/usr/share/doc/ppp-2.4.5/scripts/pon OpenVox_VPN
	关闭：/usr/share/doc/ppp-2.4.5/scripts/poff
