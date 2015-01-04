## vim

### 将 Windows 文本文件中的 ^M (回车换行)全部替换掉

	vi filename.c
	按 Esc 键，进入命令模式；
	按 : 键 (按 Shift 键不放后，同时按 : 键)进入命令输入状态
	在冒号后输入：%s/^M//g
		注：^M是一个字符不是输入^和M两个字符，
		即按住 Ctrl 键不放，同时按 V 键产生 ^，依然按住 Ctrl 键不放，同时按 M 产生 M
	按 Enter 键，执行替换命令

### IDE中文件编码方式和行结束符设置：

	Window 下的 VS2008 中：
		[File]->[Advanced Save Options...]，
		在弹出的 "Advanced Save Options" 对话框中，设置 Encoding 为 Unicode (UTF-8 with signature) - Codepage 65001，设置 Line endings 为 Unix (LF)

	Ubuntu 下的 Code::Blocks 中：
		[Settings]->[Editor...]
		在弹出的 "Configure editor" 对话框中，点击左边框中的 General settings 选项，
		设置 Encoding 选项组中的 Use encoding when opening files 为 UTF-8，Use this encoding 为 As default encoding(bypassing C::B's auto-detection)
		设置 End-of-line options 选项组中的 End-of-line mode:LF