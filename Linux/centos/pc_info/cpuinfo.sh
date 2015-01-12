#!/bin/bash
# Filename: cpuinfo.sh
#
# cat /proc/cpuinfo：
# processor	系统中逻辑处理器的编号。
# 	对于单核处理器，可认为是其 CPU 编号；
# 	对于多核处理器，可以是物理核或者使用超线程技术虚拟的逻辑核
# vendor_id	CPU 制造商
# cpu family	CPU 产品系列代号
# model		CPU 属于其系列中的哪一代的代号
# model name	CPU 属于的名字及其编号、标称主频
# stepping	CPU 属于制作更新版本
# cpu MHz	CPU 的实际使用主频
# cache size	CPU 二级缓存大小
# 
# physical id	单个 CPU 的标号
# siblings	单个 CPU 逻辑物理核数
# core id	当前物理核在其所处 CPU 中的编号，这个编号不一定连续
# cpu cores	该逻辑核所处 CPU 的物理核数
# apicid	用来区分不同逻辑核的编号，系统中每个逻辑核的此编号必然不同，此编号不一定连续
# 
# fdiv_bug
# hlt_bug
# f00f_bug
# coma_bug
# fpu		是否具有浮点运算单元（Floating Point Unit）
# fpu_exception	是否支持浮点计算异常
# cpuid level	执行 cpuid 指令前，eax 寄存器中的值，根据不同的值 cpuid 指令会返回不同的内容
# wp		表明当前 CPU 是否在内核态支持对用户空间的写保护（Write Protection）
# flags		当前 CPU 支持的功能
# 	fpu	Onboard (x87) Floating Point Unit
# 	vme	Virtual Mode Extension
# 	de	Debugging Extensions
# 	pse	Page Size Extensions
# 	tsc	Time Stamp Counter
# 			support for RDTSC and WRTSC instructions
# 	msr	Model-Specific Registers
# 	pae	Physical Address Extensions
# 			ability to access 64GB of memory; only 4GB can be accessed at a time though
# 	mce	Machine Check Architecture
# 	cx8	CMPXCHG8 instruction
# 	apic	Onboard Advanced Programmable Interrupt Controller
# 	sep	Sysenter/Sysexit Instructions;
# 			SYSENTER is used for jumps to kernel memory during system calls,
# 			and SYSEXIT is used for jumps： back to the user code
# 	mtrr	Memory Type Range Registers
# 	pge	Page Global Enable
# 	mca	Machine Check Architecture
# 	cmov	CMOV instruction
# 	pat	Page Attribute Table
# 	pse36	36-bit Page Size Extensions
# 			allows to map 4 MB pages into the first 64GB RAM, used with PSE.
# 	pn	Processor Serial-Number; only available on Pentium 3
# 	clflush	CLFLUSH instruction
# 	dtes	Debug Trace Store
# 	acpi	ACPI via MSR
# 	mmx	MultiMedia Extension
# 	fxsr	FXSAVE and FXSTOR instructions
# 	sse	Streaming SIMD Extensions
# 			Single instruction multiple data.
# 			Lets you do a bunch of the same operation on different pieces of input： in a single clock tick.
# 	sse2	Streaming SIMD Extensions-2. More of the same.
# 	selfsnoop	CPU self snoop
# 	acc	Automatic Clock Control
# 	IA64	IA-64 processor Itanium.
# 	ht	HyperThreading.
# 			Introduces an imaginary second processor that doesn’t do much but lets you run threads in the same process a  bit quicker.
# 	nx	No Execute bit. Prevents arbitrary code running via buffer overflows.
# 	pni	Prescott New Instructions aka. SSE3
# 	vmx	Intel Vanderpool hardware virtualization technology
# 	svm	AMD "Pacifica" hardware virtualization technology
# 	lm	"Long Mode" which means the chip supports the AMD64 instruction set
# 	tm	"Thermal Monitor" Thermal throttling with IDLE instructions. Usually hardware controlled in response to CPU temperature.
# 	tm2	"Thermal Monitor 2" Decrease speed by reducing multipler and vcore.
# 	est	Enhanced SpeedStep
# bogomips	在系统内核启动时粗略测算的 CPU 速度（Million Instructions Per Second）
# clflush size	每次刷新缓存的大小单位
# cache_alignment	缓存地址对齐单位
# address sizes	可访问地址空间位数
# power management	对能源管理的支持，有以下几个可选支持功能：
# 	ts	temperature sensor
# 	fid	frequency id control
# 	vid	voltage id control
# 	ttp	thermal trip
# 	tm
# 	stc
# 	100mhzsteps
# 	hwpstate
#
# 具有相同 core id 的 cpu 是同一 core 的超线程
# 具有相同 physical id 的 cpu 是同一 cpu 封装的线程或者 cores

# 物理 cpu 个数
cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
grep 'physical id' /proc/cpuinfo | sort -u

# 核心数量
grep 'core id' /proc/cpuinfo | sort -u | wc -l

# 线程数
grep 'processor' /proc/cpuinfo | sort -u | wc -l

# 逻辑 CPU 个数
cat /proc/cpuinfo | grep "processor" | wc -l

# CPU 物理核数
cat /proc/cpuinfo | grep "cpu cores" | uniq

# CPU 是否启用超线程
# 如果 cpu cores 数量和 siblings 数量一致，则没有启用超线程，否则超线程被启用。
cat /proc/cpuinfo | grep -e "cpu cores"  -e "siblings" | sort | uniq

