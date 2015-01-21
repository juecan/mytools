## mount

### 挂载 U 盘

	[~]# fdisk -l

	Disk /dev/sda: 160.0 GB, 160041885696 bytes, 312581808 sectors
	Units = sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk label type: dos
	Disk identifier: 0x000a9776

	   Device Boot      Start         End      Blocks   Id  System
	/dev/sda1   *        2048     1026047      512000   83  Linux
	/dev/sda2         1026048   312580095   155777024   8e  Linux LVM

	Disk /dev/mapper/centos-swap: 2181 MB, 2181038080 bytes, 4259840 sectors
	Units = sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes


	Disk /dev/mapper/centos-root: 53.7 GB, 53687091200 bytes, 104857600 sectors
	Units = sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes


	Disk /dev/mapper/centos-home: 103.6 GB, 103645446144 bytes, 202432512 sectors
	Units = sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes


	Disk /dev/sdb: 4008 MB, 4008706048 bytes, 7829504 sectors
	Units = sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk label type: dos
	Disk identifier: 0x000692ea

	   Device Boot      Start         End      Blocks   Id  System
	/dev/sdb1   *        2048      497663      247808   83  Linux
	/dev/sdb2          497664     7796735     3649536   83  Linux

	[~]# e2label /dev/sdb1
	System
	[~]# e2label /dev/sdb2
	Storage

	[~]# mount -t ext4 /dev/sdb2 /media/Storage

	[~]# blkid 
	/dev/sda1: UUID="1d041c9c-cc9b-414c-b73b-9ec208bcd82c" TYPE="xfs" 
	/dev/sda2: UUID="OoaUqQ-NSWq-hu3H-3TTs-QTd4-IwGX-SoO7tY" TYPE="LVM2_member" 
	/dev/mapper/centos-swap: UUID="94001069-7645-43e0-ad91-43fbb15c4b70" TYPE="swap" 
	/dev/mapper/centos-root: UUID="e231a1f1-cb1c-4c8e-ab21-6ec865ace50a" TYPE="xfs" 
	/dev/mapper/centos-home: UUID="d0fd83a8-6692-4b8d-9097-48e48063cb27" TYPE="xfs" 
	/dev/sdb1: LABEL="System" UUID="24c0d03e-def3-4cf2-943a-a6488c4b2e1c" TYPE="ext4" 
	/dev/sdb2: LABEL="Storage" UUID="5fa4d600-7c63-41f3-9955-21c9e2410b95" TYPE="ext4"

	[~]# lsusb

	[~]# dmesg
	[774535.425035] usb 1-4: new high-speed USB device number 2 using ehci-pci
	[774535.539916] usb 1-4: New USB device found, idVendor=8644, idProduct=800a
	[774535.539923] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
	[774535.539928] usb 1-4: Product: USB Flash Disk  
	[774535.539932] usb 1-4: Manufacturer: General 
	[774535.539936] usb 1-4: SerialNumber: 5B9B1CF31ED61197
	[774535.742231] usb-storage 1-4:1.0: USB Mass Storage device detected
	[774535.742342] scsi4 : usb-storage 1-4:1.0
	[774535.742447] usbcore: registered new interface driver usb-storage
	[774536.743572] scsi 4:0:0:0: Direct-Access     Teclast  CoolFlash        1.00 PQ: 0 ANSI: 2
	[774536.744265] sd 4:0:0:0: Attached scsi generic sg1 type 0
	[774536.745063] sd 4:0:0:0: [sdb] 7829504 512-byte logical blocks: (4.00 GB/3.73 GiB)
	[774536.746568] sd 4:0:0:0: [sdb] Write Protect is off
	[774536.746576] sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
	[774536.747562] sd 4:0:0:0: [sdb] No Caching mode page found
	[774536.747587] sd 4:0:0:0: [sdb] Assuming drive cache: write through
	[774536.751675] sd 4:0:0:0: [sdb] No Caching mode page found
	[774536.751693] sd 4:0:0:0: [sdb] Assuming drive cache: write through
	[774536.752816]  sdb: sdb1 sdb2
	[774536.756050] sd 4:0:0:0: [sdb] No Caching mode page found
	[774536.756069] sd 4:0:0:0: [sdb] Assuming drive cache: write through
	[774536.756083] sd 4:0:0:0: [sdb] Attached SCSI removable disk
	[775244.125672] EXT4-fs (sdb2): recovery complete
	[775244.125680] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)

	[~]# cat /proc/partitions 
	major minor  #blocks  name

	   8        0  156290904 sda
	   8        1     512000 sda1
	   8        2  155777024 sda2
	 253        0    2129920 dm-0
	 253        1   52428800 dm-1
	 253        2  101216256 dm-2
	   8       16    3914752 sdb
	   8       17     247808 sdb1
	   8       18    3649536 sdb2

	[~]# cat /proc/scsi/usb-storage/4 
	   Host scsi4: usb-storage
		   Vendor: General 
		  Product: USB Flash Disk  
	Serial Number: 5B9B1CF31ED61197
		 Protocol: Transparent SCSI
		Transport: Bulk
		   Quirks:

	函数：fstatfs/statfs

### Ubuntu 上挂载 LVM2_member

	sudo apt-get install lvm2

	[~]$ sudo vgscan 
	  Reading all physical volumes.  This may take a while...
	  Found volume group "VolGroup00" using metadata type lvm2

	[~]$ sudo vgchange -ay VolGroup00
	  2 logical volume(s) in volume group "VolGroup00" now active

	[~]$ sudo lvs
	  LV       VG         Attr      LSize  Pool Origin Data%  Move Log Copy%  Convert
	  LogVol00 VolGroup00 -wi-a---- 70.47g
	  LogVol01 VolGroup00 -wi-a----  3.94g

	现在可以挂载上了

