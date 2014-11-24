#!/bin/bash
# IAX 非注册方式

UNREGISTER_TRUNK_NAME=181TRUNK
OPPOSITE_TRUNK_NAME=74TRUNK
OPPOSITE_IP=172.16.1.74
TRUNK_SECRET=secret
IAX_CONTEXT=from-iax

{
        echo "[${UNREGISTER_TRUNK_NAME}]"                     
        echo "type=friend"                                    
        echo "host=${OPPOSITE_IP}"                            
        echo "username=${OPPOSITE_TRUNK_NAME}"                           
        echo "secret=${TRUNK_SECRET}" 
        echo "context=${IAX_CONTEXT}"
        echo ""                                               
} >> /etc/asterisk/iax.conf 

#[from-sip]
#; 非注册方式 [181TRUNK]
#exten => _1X.,1,Dial(IAX2/181TRUNK/${EXTEN:1})
#; 注册方式 [Go74]
#exten => _2X.,1,Dial(IAX2/Go74/${EXTEN:1})

#[from-iax]
#; 注意：不能使用 s
#;exten => 18101,1,Playback(demo-instruct)
#exten => 18101,1,Dial(SIP/18101)
