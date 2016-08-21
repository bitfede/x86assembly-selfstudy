#
# AUTHOR:     Jonathan Bartlett (Book Author) + Federico G. De Faveri (just a few comments)
#
# PURPOSE:    Count the characters until a null byte is reached.
#
# INPUT:      The address of the character string
#
# OUTPUT:     Returns the count in %eax
#
# PROCESS:    
#     Registers used:
#     %ecx - chacter count
#     %al  - current character
#     %edx - current character address

.code32

.type count_chars, @function
.globl count_chars

# This is to locate our one parameter on the stack

.equ ST_STRING_START_ADDRESS,   8

count_chars:
  pushl     %ebp
  movl      %esp, %ebp
  
  movl      $0, %ecx                          #Counter starts at 0
  movl ST_STRING_START_ADDRESS(%ebp), %edx    #Starting address of data
  
  count_loop_begin:
    movb    (%edx), %al                       #Grab the current char
    cmpb    $0, %al                           #is it null?
    #if yes:
    je      count_loop_end                    #go to count_loop_end
    #otherwise:
    incl    %ecx                              #increment the counter              
    incl    %edx                              #increment starting address of data pointer
    jmp     count_loop_begin                  #jump back to beginning of loop
    
  count_loop_end:
    movl    %ecx, %eax
    
    popl    %ebp
    ret
    
