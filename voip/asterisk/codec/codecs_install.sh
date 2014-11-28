#! /bin/bash
#==== Includes=====================================
    . ./install_configs.sh
    . ./mor_install_functions.sh
    . ./bash_functions.sh
#========= Functions by processor type ==================
p4_proc()
{
         set $(grep "model name" /proc/cpuinfo);
         if [ "$4" == "Celeron" ]; then
                if [ "$LOCAL_INSTALL" == "0" ]; then
                    wget http://asterisk.hosting.lv/bin/codec_g723-ast14-gcc4-glibc-pentium.so   
                    wget http://asterisk.hosting.lv/bin/codec_g729-ast14-gcc4-glibc-pentium.so
                    cp /usr/src/codec_g723-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g723.so
                    cp /usr/src/codec_g729-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g729.so
                elif [ "$LOCAL_INSTALL" == "1" ]; then
                    cp /usr/src/other/codecs/codec_g723-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g723.so
                    cp /usr/src/other/codecs/codec_g729-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g729.so
                fi         
               return 0; #stop futher script execution
         fi
        if [ -r codec_g723-ast14-gcc4-glibc-pentium4.so ] && [ -r codec_g729-ast14-gcc4-glibc-pentium4.so ];
      then echo "codec_g723-ast14-gcc4-glibc-pentium4.so and codec_g729-ast14-gcc4-glibc-pentium4.so is already downloaded and installed";
      else 
            if [ "$LOCAL_INSTALL" == "0" ]; then
               wget http://asterisk.hosting.lv/bin/codec_g723-ast14-gcc4-glibc-pentium4.so   
               wget http://asterisk.hosting.lv/bin/codec_g729-ast14-gcc4-glibc-pentium4.so
               mv /usr/src/codec_g723-ast14-gcc4-glibc-pentium4.so /usr/lib/asterisk/modules/codec_g723.so
               mv /usr/src/codec_g729-ast14-gcc4-glibc-pentium4.so /usr/lib/asterisk/modules/codec_g729.so
            elif [ "$LOCAL_INSTALL" == "1" ]; then
               cp /usr/src/other/codecs/codec_g723-ast14-gcc4-glibc-pentium4.so /usr/lib/asterisk/modules/codec_g723.so
               cp /usr/src/other/codecs/codec_g729-ast14-gcc4-glibc-pentium4.so /usr/lib/asterisk/modules/codec_g729.so
            fi
   fi
}
p4_x64_proc()
{  if [ -r codec_g723-ast14-gcc4-glibc-x86_64-pentium4.so ] && [ -r codec_g729-ast14-gcc4-glibc-x86_64-pentium4.so ];
      then echo "codec_g723-ast14-gcc4-glibc-x86_64-pentium4.so and codec_g729-ast14-gcc4-glibc-x86_64-pentium4.so is already downloaded and installed";
      else 
            if [ $LOCAL_INSTALL == 0 ]; then
               wget http://asterisk.hosting.lv/bin/codec_g723-ast14-gcc4-glibc-x86_64-pentium4.so
               wget http://asterisk.hosting.lv/bin/codec_g729-ast14-gcc4-glibc-x86_64-pentium4.so
               mv /usr/src/codec_g723-ast14-gcc4-glibc-x86_64-pentium4.so /usr/lib/asterisk/modules/codec_g723.so
               mv /usr/src/codec_g729-ast14-gcc4-glibc-x86_64-pentium4.so /usr/lib/asterisk/modules/codec_g729.so
            elif [ $LOCAL_INSTALL == 1 ]; then
               cp /usr/src/other/codecs/codec_g729-ast14-gcc4-glibc-x86_64-pentium4.so /usr/lib/asterisk/modules/codec_g729.so
               cp /usr/src/other/codecs/codec_g723-ast14-gcc4-glibc-x86_64-pentium4.so /usr/lib/asterisk/modules/codec_g723.so
            fi
   fi
}
p3_proc()
{  if [ -r codec_g723-ast14-gcc4-glibc-pentium3.so ] && [ -r codec_g729-ast14-gcc4-glibc-pentium3.so ];
      then echo "codec_g723-ast14-gcc4-glibc-pentium3.so and codec_g729-ast14-gcc4-glibc-pentium3.so is already downloaded and installed";
      else
            if [ "$LOCAL_INSTALL" == "0" ]; then
                                        #for model name : Intel(R) Pentium(R) III CPU family 1266MHz ====
                                        set $(grep "model name" /proc/cpuinfo);
                                        if [ "$4" == "Intel(R)" &&  "$5" == "Pentium(R)" && "$6"== "III" ];then
                                                wget http://asterisk.hosting.lv/bin/codec_g723-ast14-gcc4-glibc-pentium.so   
                                                wget http://asterisk.hosting.lv/bin/codec_g729-ast14-gcc4-glibc-pentium.so
                                                cp /usr/src/codec_g723-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g723.so
                                                cp /usr/src/codec_g729-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g729.so
                                                return 0;
                                        fi
                                        #================================================================
               wget http://asterisk.hosting.lv/bin/codec_g723-ast14-gcc4-glibc-pentium3.so
               wget http://asterisk.hosting.lv/bin/codec_g729-ast14-gcc4-glibc-pentium3.so
               mv /usr/src/codec_g723-ast14-gcc4-glibc-pentium3.so /usr/lib/asterisk/modules/codec_g723.so
               mv /usr/src/codec_g729-ast14-gcc4-glibc-pentium3.so /usr/lib/asterisk/modules/codec_g729.so
            elif [ $LOCAL_INSTALL == 1 ]; then
                                        #for model name : Intel(R) Pentium(R) III CPU family 1266MHz=====
                                        set $(grep "model name" /proc/cpuinfo);
                                        if [ "$4" == "Intel(R)" &&  "$5" == "Pentium(R)" && "$6"== "III" ];then
                                                cp /usr/src/other/codecs/codec_g723-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g723.so
                                      cp /usr/src/other/codecs/codec_g729-ast14-gcc4-glibc-pentium.so /usr/lib/asterisk/modules/codec_g729.so
                                                return 0;
                                        fi
                                        #============================================================
               cp /usr/src/other/codecs/codec_g723-ast14-gcc4-glibc-pentium3.so /usr/lib/asterisk/modules/codec_g723.so
               cp /usr/src/other/codecs/codec_g729-ast14-gcc4-glibc-pentium3.so /usr/lib/asterisk/modules/codec_g729.so
            fi
   fi 
}
AMD_proc()
{  if [ -r codec_g729-ast14-gcc4-glibc-athlon-sse.so ] && [ -r codec_g723-ast14-gcc4-glibc-athlon-sse.so ];
      then echo "codec_g729-ast14-gcc4-glibc-athlon-sse.so and codec_g723-ast14-gcc4-glibc-athlon-sse.so is already downloaded and installed";
      else       
            if [ $LOCAL_INSTALL == 0 ]; then
               wget http://asterisk.hosting.lv/bin/codec_g729-ast14-gcc4-glibc-athlon-sse.so
               wget http://asterisk.hosting.lv/bin/codec_g723-ast14-gcc4-glibc-athlon-sse.so
               mv /usr/src/codec_g723-ast14-gcc4-glibc-athlon-sse.so /usr/lib/asterisk/modules/codec_g723.so
               mv /usr/src/codec_g729-ast14-gcc4-glibc-athlon-sse.so /usr/lib/asterisk/modules/codec_g729.so
            elif [ $LOCAL_INSTALL == 1 ]; then
               cp /usr/src/other/codecs/codec_g729-ast14-gcc4-glibc-athlon-sse.so /usr/lib/asterisk/modules/codec_g729.so
               cp /usr/src/other/codecs/codec_g723-ast14-gcc4-glibc-athlon-sse.so /usr/lib/asterisk/modules/codec_g723.so
            fi
   fi
}
#======= Main ====================

    asterisk_current_version
    STRIPPED_VERSION=`echo $ASTERISK_VERSION | cut -c -3`
    if [ "$STRIPPED_VERSION" == "1.8" ]; then
        report "Currently codecs are supported only for Asterisk 1.4. Skipping codecs installation" 3
        exit 0    
    fi

  # clear;
   echo "INSTALLING G723 and G729 CODECS.........";   
   cd /usr/src
   rm -rf codec_*
   processor_type;  # generating _64BIT variable (0/1, standing for False/True)
   _IS_AMD=`cat /proc/cpuinfo | grep AMD`;
   _P3=`cat /proc/cpuinfo | grep "Pentium III"`;
        _P3_R=`cat /proc/cpuinfo | grep "Pentium(R) III"`;
   _INTEL=`cat /proc/cpuinfo | grep Intel`;
   if [ -n "$_IS_AMD" ];
      then 
         echo "Processor type detected: AMD";
         if  [ "$_64BIT" == 1 ]; then echo "It is a x64 proc";
                                       p4_x64_proc;
                                 else AMD_proc;
         fi
       
                elif [ -n "$_P3_R" ]; then echo "Pentium(R) III processor detected"; p3_proc;           
      elif [ "$_64BIT" == 1 ]; then echo "Processor type detected: INTEL x64"; p4_x64_proc;       
      elif [ -n "$_INTEL" ]; then echo "Pentium IV processor detected"; p4_proc;
      elif [ -n "$_P3" ]; then echo "Pentium III processor detected"; p3_proc;
      else
         echo -e "Automatic detection of required codec installation script failed\nYou must manually select and install the required codec according to this output:";
         cat /proc/cpuinfo
         uname -a
         echo "you can find codecs installation scripts in /usr/src/mor/codecs folder";
   fi;
   chmod 777 /usr/lib/asterisk/modules/codec_g72*
   asterisk_stop;
   /etc/init.d/asterisk restart
   sleep 10
   asterisk -vvvvrx 'core show translation'
