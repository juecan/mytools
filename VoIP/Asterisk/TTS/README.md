# Asterisk TTS

	TTS: Text to Speech，文字转语音

[OSSLAB TTS](http://www.osslab.org.tw/VoIP/IP_PBX/%E8%BB%9F%E9%AB%94%E5%BC%8F_IP_PBX/Asterisk_-_%E5%85%8D%E8%B2%BB_IP_PBX_%E7%B6%B2%E8%B7%AF%E9%9B%BB%E8%A9%B1%E4%BA%A4%E6%8F%9B%E5%B9%B3%E5%8F%B0/Addons/TTS_-_%E6%96%87%E5%AD%97%E8%BD%89%E8%AA%9E%E9%9F%B3)

## eSpeak

	支持中文

### 安装

	yum install libsndfile libsndfile-devel
	yum install libsamplerate libsamplerate-devel

	下载安装 portaudio：http://www.portaudio.com/
	tar -xvf pa_stable_v19_20140130.tgz
	cd portaudio
	./configure && make && make install

	下载安装 espeak：
	cd espeak-1.48.04-source/src
	cp portaudio.h portaudio.h.bak
	cp portaudio19.h portaudio.h
	make
	make install

	下载安装 Asterisk-eSpeak：https://github.com/zaf/Asterisk-eSpeak
	unzip Asterisk-eSpeak-master.zip
	cd Asterisk-eSpeak-master
	make
	make install
	make samples

> 编译 espeak 过程中如果出现：wavegen.cpp:(.text+0x21c9): undefined reference to `Pa_StreamActive'，配置方法如下：
> 
> cp portaudio.h portaudio.h.bak
> 
> cp portaudio19.h portaudio.h
> 
> 再 make

### 使用

	vim /etc/asterisk/espeak.conf
		[voice]
		voice=zh
	vim /etc/asterisk/extensions.conf
		exten => _X.,n,Espeak("您好，这里是开源通信有限公司！",zh)
		or
		exten => _X.,n,Espeak("您好，这里是开源通信有限公司！",any)
		or
		exten => _X.,n,Espeak("您好，这里是开源通信有限公司！")

## Festival

	不支持中文

	yum install festival

	在文件 /usr/share/festival/lib/festival.scm 末尾添加如下内容，以使 Asterisk 连接 Festival 服务
		(define (tts_textasterisk string mode)
		"(tts_textasterisk STRING MODE)
		Apply tts to STRING. This function is specifically designed for
		use in server mode so a single function call may synthesize the string.
		This function name may be added to the server safe functions."
		(let ((wholeutt (utt.synth (eval (list 'Utterance 'Text string)))))
		(utt.wave.resample wholeutt 8000)
		(utt.wave.rescale wholeutt 5)
		(utt.send.wave.client wholeutt)))

	启动 Festival：
		festival_server 2>&1 > /dev/null &
	
	在 Asterisk 源码中使用 make menuselect 查看 app_festival 是否勾选，未勾选需重新编译安装
		cp /usr/src/asterisk-13.1.0/configs/samples/festival.conf.sample /etc/asterisk/festival.conf
	
	Asterisk CLI 中：
		core show application festival
		module load app_festival.so
	
	设置拨号规则：
		exten => _2X.,1,Answer()                                      
		;exten => _2X.,n,Festival("hello world")                      
		exten => _2X.,n,System(echo "Hell everyone, my name is Michael." | /usr/bin/text2wave -scale 1.5 -F 8000 -o /tmp/festival.wav)                                                             
		exten => _2X.,n,Playback(/tmp/festival)                       
		exten => _2X.,n,System(rm -f /tmp/festival.wav)               
		exten => _2X.,n,Hangup()
