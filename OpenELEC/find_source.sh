#!/bin/bash
# Filename: find_source.sh

save_file="package.txt"
openelec_path="/home/along/Project/OpenELEC/src/OpenELEC.tv-4.2.1"
openelec_version=`sed -n '/OPENELEC_VERSION=/p' ${openelec_path}/config/version | cut -d '"' -f 2`
distro_src=$(sed -n '/DISTRO_SRC=/p' ${openelec_path}/projects/Generic/options | cut -d '"' -f 2 | sed "s/\$OPENELEC_VERSION/${openelec_version}/g" | sed "s#/#\\\\/#g")
sourceforge_src=$(sed -n '/SOURCEFORGE_SRC=/p' ${openelec_path}/config/sources | cut -d '"' -f 2 | sed "s#/#\\\\/#g")

for package in `find ${openelec_path}/packages -name package.mk`
do
	pkg_name=`sed -n '/^PKG_NAME=/p' ${package} | cut -d "\"" -f 2`
	pkg_version=`sed -n '/^PKG_VERSION=/p' ${package} | cut -d "\"" -f 2`
	pkg_url=$(sed -n '/^PKG_URL=/p' ${package} | cut -d '"' -f 2 | sed "s/\$DISTRO_SRC/${distro_src}/g" | sed "s/\${DISTRO_SRC}/${distro_src}/g" | sed "s/\$PKG_NAME/${pkg_name}/g" | sed "s/\${PKG_NAME}/${pkg_name}/g" | sed "s/\$PKG_VERSION/${pkg_version}/g" | sed "s/\${PKG_VERSION}/${pkg_version}/g" | sed "s/\$SOURCEFORGE_SRC/${sourceforge_src}/g" | sed "s/\${SOURCEFORGE_SRC}/${sourceforge_src}/g")

	if [ ! -z ${pkg_url} ]
	then
		echo ${pkg_url} >> ${save_file}
	fi
done
