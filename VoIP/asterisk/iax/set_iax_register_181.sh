#!/bin/bash
# IAX 注册方式

OPPOSITE_IP=172.16.1.74
OPPOSITE_RECEIVE_TRUNK_NAME=for181
TRUNK_SECRET=secret
REGISTER_RESEIVE_TRUNK=for74
REGISTER_SEND_TRUNK=Go74
IAX_CONTEXT=from-iax

echo "请手动添加如下信息："
echo "[general]"
echo "register => ${OPPOSITE_RECEIVE_TRUNK_NAME}:${TRUNK_SECRET}@${OPPOSITE_IP}"
echo ""

{
	# 可往对端拨号
	echo "[${REGISTER_SEND_TRUNK}]"
	echo "type=peer"
	echo "host=${OPPOSITE_IP}"
	echo "username=${OPPOSITE_RECEIVE_TRUNK_NAME}"
	echo "secret=${TRUNK_SECRET}"
	echo ""
	# 接收对端拨号请求
	echo "[${REGISTER_RESEIVE_TRUNK}]"
	echo "type=user"
	echo "host=dynamic"
	echo "secret=${TRUNK_SECRET}"
	echo "context=${IAX_CONTEXT}"
	echo ""
} >> /etc/asterisk/iax.conf

echo "已写入/etc/asterisk/iax.conf"
echo ""

#[from-sip]
#; 非注册方式 [181TRUNK]
#exten => _1X.,1,Dial(IAX2/181TRUNK/${EXTEN:1})
#; 注册方式 [Go74]
#exten => _2X.,1,Dial(IAX2/Go74/${EXTEN:1})

#[from-iax]
#; 注意：不能使用 s
#;exten => 18101,1,Playback(demo-instruct)
#exten => 18101,1,Dial(SIP/18101)

