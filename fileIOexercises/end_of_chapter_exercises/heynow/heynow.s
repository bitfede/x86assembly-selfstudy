#
# AUTHOR:       Federico G. De Faveri
#
# PURPOSE:      This program creates a file called heynow.txt and writes the words
#               "Ciao belli!" in it.
#

.code32

.section .data

filename_hey:
  .byte 'h','e','y','n','o','w','.','t','x','t',0
  
string_toprint:
  .byte 'C','i','a','o',' ','b','e','l','l','i','!',0

  ######### CONSTANTS #########
  
  .equ END_OF_STRING, 0
  .equ CHAR_SIZE, 1
  .equ TEST_NUM, 4444

  # System call numbers

  .equ SYS_OPEN,   5
  .equ SYS_WRITE,  4
  .equ SYS_READ,   3
  .equ SYS_CLOSE,  6
  .equ SYS_EXIT,   1

  # Options for file actions

  .equ O_CREAT_WRONLY_TRUNC, 03101

  # Standard file descriptors

  .equ STDIN,      0
  .equ STDOUT,     1
  .equ STDERR,     2

  # System call interrupt

  .equ LINUX_SYSCALL, 0x80


.section .bss

.equ BUFFER_SIZE, 15
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text


.globl _start

_start:
  
  
  start_loop:
    movl   $0, %ecx                         #clear register with zeroes
    movl   $0 , %edi                        #preparing the counter
    movl   $filename_hey, %esi
    
    #loop that writes filename to buffer
    startloop:
      movl (%esi, %edi, 1), %eax
      cmpl $END_OF_STRING, %eax
      je endloop
      movl %eax, BUFFER_DATA(,%edi,1)
#      addl $CHAR_SIZE, %esi
      incl %edi
      jmp startloop
      
    endloop:
    
    #to write to STDOUT we do this
    movl   $BUFFER_SIZE , %edx 
    movl   $SYS_WRITE, %eax                 #puts the type of command we want to execute
    movl   $STDOUT, %ebx                    #we tell linux we want to write to STOUD file descriptor
    movl   $BUFFER_DATA, %ecx      
    int     $LINUX_SYSCALL                   
    movl    %ecx, %ebx
    
    #close STDOUT
    movl $SYS_CLOSE, %eax                 #
    movl $STDOUT, %ebx
    int $LINUX_SYSCALL
    

  movl    $SYS_EXIT , %eax
  int     $LINUX_SYSCALL
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
