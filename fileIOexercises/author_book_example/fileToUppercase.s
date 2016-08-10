#
# AUTHOR:           Jonathan Bartlett (book author, this is an example I'm copying from the ebok)
#
# PURPOSE:          This program will convert an input file to an output file with all letters converted to uppercase
#
# PROCESSING:       1- open the input file
#                   2- open the output file
#                   3- While we are not at the end of the input file
#                      a- read part of the file into out memory buffer
#                      b- go through each byt of memory, if the byte is lowercase convert to uppercase
#                      c- write memory buffer to output file

.section .data

##### CONSTANTS #####

# System call numbers

.equ SYS_OPEN,   5
.equ SYS_WRITE,  4
.equ SYS_READ,   3
.equ SYS_CLOSE,  6
.equ SYS_EXIT,   1

# Options for open

.equ O_RDONLY,   0
.equ O_CREAT_WRONLY_TRUNC, 03101

# Standard file descriptors

.equ STDIN,      0
.equ STDOUT,     1
.equ STDERR,     2

# System call interrupt

.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0                       #the return value of read, which means we've hit the end of the file

.equ NUMBER_ARGUMENTS, 2              

.section .bss

# Buffer - This is where the data is loaded into from the data file and written from
#          into the output file. This should never exceed 16,000 for various reasons

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE           #lcomm will create a symbol BUFFER_DATA that refers to a 500 byte storage location
                                          #that we can use as a buffer

.section .text

#STACK POSITIONS

.equ ST_SIZE_RESERVE,  8
.equ ST_FD_IN,        -4
.equ ST_FD_OUT,       -8
.equ ST_ARGC,          0                  #number of arguments
.equ ST_ARGV_0,        4                  #name of program
.equ ST_ARGV_1,        8                  #input file name
.equ ST_ARGV_2,        12                 #output file name

.globl _start
_start:
  ##### INITIALIZE PROGRAM #####

  movl        %esp, %ebp                  #save the stack pointer
  subl        $ST_SIZE_RESERVE, %esp      #allocate space for our file descriptors in the stack

  open_files:
  open_fd_in:
  ##### OPEN INPUT FILE #####
    movl  $SYS_OPEN, %eax                   #open syscall
    movl ST_ARGV_1(%ebp), %ebx              #input filename into %ebx
    movl $O_RDONLY, %ecx                    #input the read-only flag
    movl $0666, %edx                        #input file permissions
    int $LINUX_SYSCALL                      #send interrupt to linux
  
  store_fd_in:
  ##### SAVE THE INPUT FILE-DESCRIPTOR #####
    movl %eax, ST_FD_IN(%ebp)               #save the given file descriptor
    
  open_fd_out:
  ##### OPEN THE OUTPUT FILE #####
    movl $SYS_OPEN, %eax                    #open the file
    movl ST_ARGV_2(%ebp), %ebx              #input the file name into %ebx
    movl $O_CREAT_WRONLY_TRUNC, %ecx        #flag that allows me to write to file
    movl $0666, %edx                        #permissions for new file (if created)
    int $LINUX_SYSCALL                      #send interrupt signal to linux kernel
    
  store_fd_out:
  ##### STORE THE OUTPUT FILE-DESCRIPTOR #####
    movl %eax, ST_FD_OUT(%ebp)              #store the file descriptor here
    
    
    #TODO main loop
  
  
  
  



















                                        
