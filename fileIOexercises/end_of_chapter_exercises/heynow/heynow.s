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
  
string_towrite:
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
  
  .equ ST_NEWFILE_DSCR, -4

.globl _start

_start:
  
    #preparing to write filename 'heynow.txt' into buffer
    movl   $0, %ecx                         #clear register with zeroes
    movl   $0 , %edi                        #preparing the counter
    movl   $filename_hey, %esi
    
    #loop that actually writes filename to buffer
    startloop:
      movb     (%esi, %edi, 1), %al         #move 1 byte of data %edi steps from %esi, 1 byte at a time
      cmpb     $END_OF_STRING, %al          #check if the byte we just read is the string null terminator
      je       endloop                      #if it is go to the end of the loop
      movb     %al, BUFFER_DATA(,%edi,1)    #if it is not, move that byte into our buffer, %edi steps away, 1 byte at a time
      incl     %edi                         #increase %edi by one (look at the lines above to understand why)
      jmp      startloop                    #go back to the start of the loop
      
    endloop:
    
    ##### DEBUG CHECK CONTENT OF BUFFER_DATA #####
    #movl   $BUFFER_SIZE , %edx              #put the size of the buffer in %edx register
    #movl   $SYS_WRITE, %eax                 #puts the type of command we want to execute
    #movl   $STDOUT, %ebx                    #we tell linux we want to write to STOUD file descriptor
    #movl   $BUFFER_DATA, %ecx               #put the actual data to be written in %ecx
    #int     $LINUX_SYSCALL                  #call linux kernel
    
    ##### close STDOUT #####
    #movl $SYS_CLOSE, %eax                   #put sysclose command      
    #movl $STDOUT, %ebx                      #give file descriptor
    #int $LINUX_SYSCALL                      #call linux kernel
    

    #### CREATE FILE heynow.txt ####
    
    movl    $SYS_OPEN, %eax                     #send the open file system command into %eax
    movl    $BUFFER_DATA, %ebx                  #put the name of the file into %ebx
    movl    $O_CREAT_WRONLY_TRUNC, %ecx         #flags for writing into file
    movl    $0666, %edx                         #set file permissions
    int     $LINUX_SYSCALL                      #wake up linux kernel
    
    movl    %eax, ST_NEWFILE_DSCR(%ebp)
    
    #### READ FROM .DATA THE STRING TO BE PRINTED ####
    #clear registers
    movl    $0, %eax
    movl    $0, %ecx 
    movl    $0, %esi
    movl    $0, %edi
    
    movl    $string_towrite, %esi
    
    stringtowrite_loop:
        
        movb    (%esi, %edi, 1), %al            #read 1 byte from the %esi register, which has the address
                                                #of the .data we need
        cmpb    $END_OF_STRING, %al             #check if what you just read is the end of the string
        je      stringtowrite_end_loop          #if it is go to the end of the loop
        movb    %al, BUFFER_DATA(, %edi, 1)     #write that byte in our buffer data memory
        incl    %edi                            #increase the counter by one, so next time we read/write one step further
        jmp     stringtowrite_loop
        
        
    stringtowrite_end_loop:
    
    
    ##### DEBUG CHECK CONTENT OF BUFFER_DATA #####
    #movl   $BUFFER_SIZE , %edx              #put the size of the buffer in %edx register
    #movl   $SYS_WRITE, %eax                 #puts the type of command we want to execute
    #movl   $STDOUT, %ebx                    #we tell linux we want to write to STOUD file descriptor
    #movl   $BUFFER_DATA, %ecx               #put the actual data to be written in %ecx
    #int     $LINUX_SYSCALL                  #call linux kernel
    
    ##### close STDOUT #####
    #movl $SYS_CLOSE, %eax                   #put sysclose command      
    #movl $STDOUT, %ebx                      #give file descriptor
    #int $LINUX_SYSCALL                      #call linux kernel
    
    
    #### WRITE STRING TO FILE ####
    
    movl    $SYS_WRITE
    
    
    ### EXIT PROGRAM ###

    movl    $SYS_EXIT , %eax
    int     $LINUX_SYSCALL
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
