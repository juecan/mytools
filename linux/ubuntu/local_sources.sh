#!/bin/bash
# Filname: 
# 制作 ubuntu 离线安装源

# 软件名称
NAME=$1
# 软件包存放位置
SOURCE_DIR=/home/along/sources_packages

cd ${SOURCE_DIR}

cp -r /var/cache/apt/archives ${NAME}
dpkg-scanpackages ${NAME} /dev/null | gzip > ${NAME}/Packages.gz

echo "deb file://${SOURCE_DIR} ${NAME}/" >> ${SOURCE_DIR}/sources.list.local

