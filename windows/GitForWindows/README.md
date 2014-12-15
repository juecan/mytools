## Git For Windows

### Git GUI 中文断码

	方法一：在Bash提示符下输入：git config --global gui.encoding utf-8
	方法二：GitGUI - 编辑 - 选项 - Default File Contents Encoding - utf-8
	
	注：通过上述设置，UTF-8 编码的文本文件可以正常查看，但是 GBK 编码的文件将会乱码
		可行的方法之一为：将所有文本文件的编码统一为 UTF-8 或 GBK，然后设置相应的 gui.encoding 参数为 utf-8 或 gbk