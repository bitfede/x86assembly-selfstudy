#
# LANGUAGE:         x86_32-pc-linux-gnu Assembly  
#
# AUTHOR:           Federico G. De Faveri
#
# PURPOSE:          This Program will calculate the factorial of a given number
#
#
#

.code32

.section .data

.section .text


.globl _start

_start:
  
  movl     $6, %ebx                    #put the number that you want to calculate the factorial into ebx
  pushl    %ebx                        #push number on the stack, this number is the first parameter of the
                                       #function factorial
                                       
 # call     factorial
  
  addl     $4, %esp                    #returns stack pointer register to the pre-function situation
  movl     %eax, %ebx                  #moves the returned value into ebx,so we can print it in stdout with echo $?
  
  movl     $1, %eax                    #puts the end status code in the eax register
  int      $0x80                       #sends the goodnight signal to the kernel
  
  
  
  
#
# FUNCTION:        this is the factorial function, it accepts one parameter and returns its factorial
#
# PARAMETERS:      the number that needs the factorial to be taken
#

.type factorial, @function
factorial:
  
  pushl     %ebp                        #freeze the current stack frame by saving the 'old' base pointer
  movl      %esp, %ebp                  #allows me to access parameters consistently by making the stack 
                                        # pointer the base pointer
  
  #                                     #here you can make extra room for local variables
  
  #TODO factorial logic and close function
  




















