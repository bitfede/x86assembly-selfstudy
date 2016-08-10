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
    
    
  ##### BEGIN MAIN LOOP #####
  read_loop_begin:
    
    ### READ IN A BLOCK FROM THE UNPUT FILE ###
    movl $SYS_READ, %eax                    #open syscall
    movl ST_FD_IN(%ebp), %ebx               #get the unput file descriptor
    movl $BUFFER_DATA, %ecx                 #get the location to read into
    movl $BUFFER_SIZE, %edx                 #get the size of the buffer
    int  $LINUX_SYSCALL                     #size of buffer is read and returned in %eax
    
    ### EXIT IF WE HAVE REACHED THE END ###
    cmpl $END_OF_FILE, %eax
    jle end_loop                            #if found or on error, go to the end
    
  continue_read_loop:
    ### CONVERT BLOCK TO UPPER CASE ###
    pushl $BUFFER_DATA                      #location of buffer
    pushl %eax                              #size of the buffer
    call convert_to_upper                   #call the function
    popl %eax                               #get the size back
    addl $4, %esp                           #restore %esp
    
    ### WRITE THE BLOCK OUT TO THE OUTPUT FILE ###
    movl %eax, %edx                         #size of the buffer
    movl $SYS_WRITE, %eax                   #open syscall
    movl ST_FD_OUT(%ebp), %ebx              #file to use
    movl $BUFFER_DATA, %ecx                 #location of the buffer
    int $LINUX_SYSCALL                      #send interrupt to linux kernel
    
    ### CONTINUE THE LOOP ###
    
    jmp read_loop_begin                     
    
  end_loop:
    ### CLOSE THE FILES ###
    #
    # NOTE: no error checking here because error conditions dont' signify anything special here
    #
    movl $SYS_CLOSE, %eax                   #open syscall to close file
    movl ST_FD_OUT(%ebp), %ebx      
    int $LINUX_SYSCALL
    
    ### EXIT ###
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
    
    
#
# PURPOSE: this function does the converstion to upper case for a block
#
# INPUT: 1- the first parameter is the location of the block of memory to convert.
#        2- the second parameter is the length of that buffer
#
# OUTPUT: This function overwrites the current content of the buffer with the upper-casified
#         version
#
# VARIABLES: %eax - beginning of buffer
#            %ebx - length of buffer
#            %edi - current buffer offset
#            %cl  - current byte being examined (first part of %ecx)
#

##### CONSTANTS #####
#the lower boundary of our search
.equ     LOWERCASE_A, 'a'
#the upper boundary of our search
.equ     LOWERCASE_Z, 'z'
#conversion between upper and lower case
.equ     UPPER_CONVERSION, 'A' - 'a' 

##### STACK STUFF #####
  
  
  



















                                        
