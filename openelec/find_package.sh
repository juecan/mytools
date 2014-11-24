#!/bin/bash
# Filename: find_package.sh

for package in `find OpenELEC.tv-4.2.1/packages -name package.mk`
do
	pkg_url=`sed -n '/^PKG_URL=/p' ${package} | cut -d "\"" -f 2`
	pkg_name=`sed -n '/^PKG_NAME=/p' ${package} | cut -d "\"" -f 2`
	pkg_version=`sed -n '/^PKG_VERSION=/p' ${package} | cut -d "\"" -f 2`
	if [ -z ${pkg_version} ]
	then
		echo ${pkg_name}
	else
		echo ${pkg_name}-${pkg_version}
	fi
done

