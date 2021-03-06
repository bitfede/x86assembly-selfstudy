#
# AUTHOR:           Jonathan Bartlett (book author, this is an example I'm copying from the ebok)
#                   Federico G. De Faveri (modified this book example to use STDOUT and STDIN instead of files)  
#
# PURPOSE:          This program will convert an input from STDIN to an output STDOUT with all letters converted to uppercase
#
# PROCESSING:       1- tell linux to use stdin as input
#                   2- tell linux to use stodut as output
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


  store_fd_in:
  ##### TELL LINUX TO READ FROM STDIN #####
    movl $STDIN, %eax
    
 
  store_fd_out:
  ##### TELL LINUX TO OUTPUT TO STDOUT #####
    movl $STDOUT , %eax              #store the file descriptor here
    
    
  ##### BEGIN MAIN LOOP #####
  read_loop_begin:
    
    ### READ IN A BLOCK FROM STDIN ###
    movl $SYS_READ, %eax                    #open syscall
    movl $STDIN, %ebx                       #get the unput file descriptor
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
    
    ### WRITE THE BLOCK OUT TO STDOUT ###
    movl %eax, %edx                         #size of the buffer
    movl $SYS_WRITE, %eax                   #open syscall
    movl $STDOUT, %ebx                      #file to use
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
    movl $STDOUT, %ebx      
    int $LINUX_SYSCALL
    
    movl $SYS_CLOSE, %eax
    movl $STDIN, %ebx
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
#length of buffer
.equ     ST_BUFFER_LEN, 8
#actual buffer
.equ     ST_BUFFER, 12

convert_to_upper:
  pushl %ebp
  movl %esp, %ebp
  
  ### SET UP VARIABLES ###
  movl ST_BUFFER(%ebp), %eax                #put begining of buffer in eax
  movl ST_BUFFER_LEN(%ebp), %ebx            #put length of buffer in ebx
  movl $0, %edi
  
  #if a buffer of zero length was given to us, we just leave
  cmpl $0, %ebx
  je end_convert_loop
  
  convert_loop:
    #get the current byte
    movb (%eax, %edi, 1), %cl
    
    #go to the next byte unless it is between 'a' and 'z'
    cmpb $LOWERCASE_A, %cl
    jl   next_byte
    cmpb $LOWERCASE_Z, %cl
    jg   next_byte
    
    #otherwise convert the byte to uppercase
    addb  $UPPER_CONVERSION, %cl
    movb  %cl, (%eax, %edi, 1)               #and store it back
  next_byte:
    incl  %edi                                #next byte
    cmpl  %edi, %ebx                          #continue unless we've reached the end

    jne   convert_loop
    
    
  end_convert_loop:
    #no return value, just leave
    movl  %ebp, %esp
    popl  %ebp
    ret
















                                        
