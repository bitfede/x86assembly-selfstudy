.code32

.section .data

.section .text


.globl _start

_start:

  movl $8 , %ebx

	addl $10 , %ebx
	

  movl $1 , %eax
  int $0x80
  
  
