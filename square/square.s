# LANGUAGE:    x86_64-pc-linux-gnu Assembly
#
# AUTHOR:      Federico De Faveri
#
# PURPOSE:     This program computes the square of a given value
#

.code32

.section .data

.section .text

.globl _start          
.globl square

_start:
  
  movl        $2, %ebx                     #put the number 2 into %ebx  
  push        %ebx                         #push the number to the stack. this is the function's parameter.
  call        square                       #call function square
  
  ###TODO
  
  
  movl        $1 , %eax
  int         $0x80

  #  
  # FUNCTION:       this is the square function
  #                 it accepts a number as a parameter and multiplies that number by itself
  #                 returns the resulting number
  #
  #
  # PARAMETERS:     1. the number to square
  #
  #
        
  .type square, @function 
square:

  pushl       %ebp                          #save the old base pointer 
  movl        %esp , %ebp                   #make the stack pointer the base pointer
                                            #optionally here you can make room for local variables for extra storage
  
  movl        8(%ebp) , %ebx                #load the first parameter to out %ebx register
  imull       %ebx, %ebx, %eax              #multiply the number in %ebx by itself and store the result in %eax, which is where 
                                            #return values usually go in functions
  
  movl        %ebp, %esp
  popl        %ebp
  ret
