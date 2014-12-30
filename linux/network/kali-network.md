## Kali Network

	/etc/network/interfaces

	# The loopback network interface
	auto lo
	iface lo inet loopback
	# The primary network interface
	allow-hotplug eth0 eth1
	iface eth0 inet dhcp
	iface eth1 inet static
        address 192.168.0.123
        netmask 255.255.255.0

### auto allow-hotplug
		
	/etc/network/interfaces 文件中一般用 auto 或者 allow-hotplug 来定义接口的启动行为

	auto <interface_name>
	在系统启动的时候启动网络接口，无论网络接口有无连接(插入网线)，如果该接口配置了 DHCP，则无论有无网线，系统都会去执行 DHCP，如果没有插入网线，则等该接口超时后才会继续。

	allow-hotplug <interface_name>
	只有当内核从该接口检测到热插拔事件后才启动该接口
	如果系统开机时该接口没有插入网线，则系统不会启动该接口，系统启动后,如果插入网线，系统会自动启动该接口
	也就是将网络接口设置为热插拔模式。
	
### iface

	iface lo inet loopback
	将 lo 设置为本地回环 loopback
	
	iface eth0 inet dhcp
	将 eth0 设置为 DHCP
	
	iface eth1 inet static
	将 eth1 设置为 static