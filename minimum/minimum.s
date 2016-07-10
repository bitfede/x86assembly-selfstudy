# LANGUAGE:    x86_64-pc-linux-gnu Assembly
#
# AUTHOR:      Federico De Faveri
#
# PURPOSE:     This program will pick the smallest number in a given list
#
# REGISTERS:   %edi - holds the index 
#              %eax - holds the current element 
#              %ebx - holds the smallest value

.code32

.section .data

data_items:                                #this is the data list of numbers
  .long 67,34,100,45,75,54,34,44,33,22,11

.section .text

.globl _start

_start:
  
  movl    $0 , %edi                        # we start at index zero,    
  
  movl    data_items(,%edi,4), %eax         #put the first element into %eax
  movl    %eax , %ebx                       #let's say the first element is the smallest for now                   
  
  start_loop:
  movl    data_items(,%edi,4), %eax         #load the following value of data_items into %eax for comparison
  cmpl    $0 , %eax                         #check if %eax is zero, IF it is we have hit the end of the data
  je      exit_loop                         #this line will be executed if zero is equal to the content of %eax
  
  incl    %edi                              #increment the value of %edi
  cmpl    %ebx , %eax                       #compare the smallest value (in %ebx) with the new one in %eax
  jge     start_loop                        #jump to the beginning of the loop if the number in %ebx is less than the number in %eax
  movl    %eax , %ebx                       #if not put %eax as the new smallest number
  
  jmp     start_loop                        #jump to the beginning of the loop


  exit_loop:

  movl    $1 , %eax                         #status code all ok
  int     $0x80                             #sends interrupt to kernel


