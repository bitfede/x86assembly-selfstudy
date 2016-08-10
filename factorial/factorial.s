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
  
  movl     $4, %ebx                    #put the number that you want to calculate the factorial into ebx
  pushl    %ebx                        #push number on the stack, this number is the first parameter of the
                                       #function factorial
                                       
  call     factorial
  
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
  
  movl      8(%ebp), %ebx               #load the first parameter in ebx
  movl      %ebx, %eax                  #load the first number into eax, which is the register that will contain the result
  
  factorial_loop:
  subl      $1, %ebx                        #decrease our factorial counter by one
  cmpl      $0, %ebx                    #checks if our counter is at zero
  je        exit_loop                   #if counter is == to zero jump to the exit of the function
  imull     %ebx, %eax                  #else multiply decreased value with eax (which will contain the final result)
  jmp       factorial_loop              #go back to the beginning of the loop
  
  
  exit_loop:
  movl      %ebp, %esp                  #bring the old base pointer back to the initial stack frame
  popl      %ebp                        #restore old ebp
  ret                                   #pops value on the top of the stack, which is the old return address, and
                                        #puts it in %eip



















