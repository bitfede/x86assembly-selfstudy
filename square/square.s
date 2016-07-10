# LANGUAGE:    x86_64-pc-linux-gnu Assembly
#
# AUTHOR:      Federico De Faveri
#
# PURPOSE:     This program simply computes the square of a given value
#

.code32

.section .data

.section .text

.globl _start          
.globl square

_start:
  
  movl        $3, %ebx                     #put the number to be squared into %ebx  
  push        %ebx                         #push the number to the stack. this is the function's parameter.
  call        square                       #call function square
  
  addl        $4, %esp                     #returns the stack pointer register to pre-function call
  movl        %eax, %ebx                   #moves the returned value in %eax to %ebx so we can print it in stdout with
                                           # the "echo $?" command
  
  movl        $1 , %eax                    #puts 1 in %eax to indicate exit status
  int         $0x80                        #sends interrupt to kernel! Goodbye!

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

  pushl       %ebp                          #save the old base pointer , freeze the current stack frame
  movl        %esp , %ebp                   #make the stack pointer the base pointer, allowing me to access parameters easily
  
  #                                         #optionally here you can make room for local variables for extra storage
  
  movl        8(%ebp) , %ebx                #load the first parameter to our %ebx register
  movl        8(%ebp) , %eax                #load the first parameter to our %eax register
  
  imull       %ebx, %eax                    #multiply the number in %ebx by the number in %eax (by itself) and store the
                                            #result in %eax, which is where return values usually go in functions
  
  movl        %ebp, %esp                    #restore the stack pointer register to the initial stack frame
  popl        %ebp                          #restore old ebp
  ret                                       #pops value on top of the stack (old return address) and puts it in %eip
