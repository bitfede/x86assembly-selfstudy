#
# AUTHOR:       Federico G. De Faveri
#
# PURPOSE:      This program creates a file called heynow.txt and writes the words
#               "Hey diddle diddle!" in it.
#

.code32

.section .data

  ######### CONSTANTS #########

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
  .equ END_OF_FILE, 0                       #the return value of read, which means we've hit the end of the file

.section .bss

.section .text

.globl _start

_start:


  movl    $SYS_EXIT , %eax
  int     $LIUNX_SYSCALL
  
