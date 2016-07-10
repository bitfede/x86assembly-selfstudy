# LANGUAGE:    x86_64-pc-linux-gnu Assembly
#
# AUTHOR:      Federico De Faveri
#
# PURPOSE:     This program takes a number, adds 10 and exits
#

.code32

.section .data

.section .text


.globl _start

_start:

  movl $8 , %ebx                #moving the value 8 into our %ebx register

	addl $10 , %ebx               #adding 10 to the current value inside %ebx
	                              # we will be able to retrieve this value by executing "echo $?" in the
	                              # terminal after program execution

  movl $1 , %eax                #giving status code 1, ready to exit
  int $0x80                     #send interrupt signal to kernel
  
  
