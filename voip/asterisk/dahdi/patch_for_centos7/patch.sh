#!/bin/bash
# Filename: 
# Information: 生成补丁、打补丁

# 原始文件
SRC=$1
# 修改后的文件
DST=$2
# 补丁文件
PATCH_FILE=$3

# 生成补丁文件
diff -Nur ${SRC} ${DST} > ${PATCH_FILE}

# 打补丁
#patch -p1 < ${PATCH_FILE}

