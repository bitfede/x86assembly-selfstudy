#
# AUTHOR: Jonathan Bartlett (Book Author) + Federico G. De Faveri (just a few extra comments)
#

.code32

.include  "linux.s"
.include  "record-def.s"

.section .data

file_name:
  .ascii "test.dat\0"
  
.section .bss

.lcomm record_buffer, RECORD_SIZE

.section .text

#This is the main program
.globl _start

_start:
  #These are the locations on the stack where we will store the input and output
  #descriptors -- FYI we could have also used memory addresses in a .data section instead
  
  .equ ST_INPUT_DESCRIPTOR,   -4
  .equ ST_OUTPUT_DESCRIPTOR,  -8
  
  movl     %esp, %ebp               #usual stuff, copy stack pointer into ebp
  subl     $8, %esp                 #allocate two slots to allocate file descriptors
  
  #Open the file
  movl     $SYS_OPEN, %eax
  movl     $file_name, %ebx
  movl     $0, %ecx                 #this says to open read-only
  movl     $0666, %edx
  int      $LINUX_SYSCALL
  
  #Save the file descriptor
  movl        %eax, ST_INPUT_DESCRIPTOR(%ebp)
  
  #Open STDOUT
  # Even tho its a constant, we are saving the output of file descriptor in a local variable so
  # that is we later decide that it isnt always going to be STDOUT, we can change it easily 
  movl        $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)
  
  record_read_loop:
    pushl       ST_INPUT_DESCRIPTOR(%ebp)
    pushl       $record_buffer   
    call        read_record
    addl        $8, %esp
    
    #Returns the number of bytes read. If it isnt the same number we requested, the it's either an 
    #end-of-file , or an error ,so we're quitting
    cmpl        $RECORD_SIZE, %eax
    jne         finished_reading
    
    #Otherwise, print out the first name
    # But first, we must know its size!
    pushl       $RECORD_FIRSTNAME + record_buffer
    call        count_chars
    addl        $4, %esp
    
    movl        %eax, %edx
    movl        ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
    movl        $SYS_WRITE, %eax
    movl        $RECORD_FIRSTNAME + record_buffer, %ecx
    int         $LINUX_SYSCALL
    
    pushl       ST_OUTPUT_DESCRIPTOR(%ebp)
    call        write_newline
    addl        $4, %esp
    
    jmp         record_read_loop
    
  finished_reading:
    movl        $SYS_EXIT, %eax
    movl        $0, %ebx
    int         $LINUX_SYSCALL

    
    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
