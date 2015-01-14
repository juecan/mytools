#!/bin/bash
#check irq numnber

cat /proc/interrupts |grep opvxg4xx |awk '{print $1}' >/tmp/irq.txt

sed -i 's/://' /tmp/irq.txt

IRQ1=`cat /tmp/irq.txt |awk 'NR==1'`
	echo "1" >  /proc/irq/$IRQ1/smp_affinity

IRQ2=`cat /tmp/irq.txt |awk 'NR==2'`
        echo "2" >  /proc/irq/$IRQ2/smp_affinity

IRQ3=`cat /tmp/irq.txt |awk 'NR==3'`
        echo "4" >  /proc/irq/$IRQ3/smp_affinity

IRQ4=`cat /tmp/irq.txt |awk 'NR==4'`
        echo "8" >  /proc/irq/$IRQ4/smp_affinity

IRQ5=`cat /tmp/irq.txt |awk 'NR==5'`
        echo "10" >  /proc/irq/$IRQ5/smp_affinity

IRQ6=`cat /tmp/irq.txt |awk 'NR==6'`
        echo "20" >  /proc/irq/$IRQ6/smp_affinity

