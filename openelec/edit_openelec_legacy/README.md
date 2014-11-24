## Tools for OpenELEC

### Prepare some scripts:
	mksquashfs:
		Download squashfs4.3.tar.gz
		tar -zxvf squashfs4.3.tar.gz
		cd squashfs4.3
		make
		cp mksquashfs DIR_OF_CONTAIN_EDIT_OPENELEC
	change_password.py

### Modify openelec system
	1. ./edit_openelec.sh first
	2. Modify
		eg: ./edit_openelec.sh passwd
	3. ./edit_openelec.sh end
