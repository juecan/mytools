## ubuntu wireshark

### ubuntu no interface

	1、添加 wireshark 用户组：
		sudo groupadd wireshark 
		或 sudo addgroup -quiet -system wireshark
	2、将 dumpcap 更改为 wireshark 用户组：
		sudo chgrp wireshark /usr/bin/dumpcap
		或 sudo chown root:wireshark /usr/bin/dumpcap
	3、让 wireshark 用户组有 root 权限使用 dumpcap：sudo chmod 4755 /usr/bin/dumpcap 
	4、将需要使用的普通用户名加入 wireshark 用户组，我的用户是“along”：
		sudo gpasswd -a along wireshark
		或 sudo usermode -a -G wireshark along

### ubuntu 无法使用，始终未响应后退出

	(wireshark:3247): Gtk-CRITICAL **: gtk_orientable_get_orientation: assertion 'GTK_IS_ORIENTABLE (orientable)' failed
	(wireshark:3247): GLib-GObject-WARNING **: invalid unclassed pointer in cast to 'GtkScrollbar'
	(wireshark:3247): GLib-GObject-WARNING **: invalid unclassed pointer in cast to 'GtkWidget'
	(wireshark:3247): GLib-GObject-WARNING **: invalid unclassed pointer in cast to 'GObject'
	(wireshark:3247): GLib-GObject-CRITICAL **: g_object_get_qdata: assertion 'G_IS_OBJECT (object)' failed
	(wireshark:3247): Gtk-CRITICAL **: gtk_widget_set_name: assertion 'GTK_IS_WIDGET (widget)' failed
	(wireshark:3247): GLib-GObject-WARNING **: invalid unclassed pointer in cast to 'GObject'
	(wireshark:3247): GLib-GObject-CRITICAL **: g_object_set_qdata_full: assertion 'G_IS_OBJECT (object)' 	failed
	(wireshark:3247): GLib-GObject-WARNING **: invalid unclassed pointer in cast to 'GtkRange'
	(wireshark:3247): Gtk-CRITICAL **: gtk_range_get_adjustment: assertion 'GTK_IS_RANGE (range)' failed
	(wireshark:3247): GLib-GObject-WARNING **: invalid unclassed pointer in cast to 'GtkOrientable'

	echo "export LIBOVERLAY_SCROLLBAR=0" >> ~/.bashrc
	. ~/.bashrc

