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
		
	/etc/network/interfaces �ļ���һ���� auto ���� allow-hotplug ������ӿڵ�������Ϊ

	auto <interface_name>
	��ϵͳ������ʱ����������ӿڣ���������ӿ���������(��������)������ýӿ������� DHCP���������������ߣ�ϵͳ����ȥִ�� DHCP�����û�в������ߣ���ȸýӿڳ�ʱ��Ż������

	allow-hotplug <interface_name>
	ֻ�е��ں˴Ӹýӿڼ�⵽�Ȳ���¼���������ýӿ�
	���ϵͳ����ʱ�ýӿ�û�в������ߣ���ϵͳ���������ýӿڣ�ϵͳ������,����������ߣ�ϵͳ���Զ������ýӿ�
	Ҳ���ǽ�����ӿ�����Ϊ�Ȳ��ģʽ��
	
### iface

	iface lo inet loopback
	�� lo ����Ϊ���ػػ� loopback
	
	iface eth0 inet dhcp
	�� eth0 ����Ϊ DHCP
	
	iface eth1 inet static
	�� eth1 ����Ϊ static