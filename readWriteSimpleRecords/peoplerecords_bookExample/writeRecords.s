#
# AUTHOR:    Jonathan Bartlett (Book Author)
#
# PURPOSE:   This function writes a record to the given file descriptor
#
# INPUT:     The file descriptor and a buffer
#
# OUTPUT:    This function produces a status code.
#

.include  "linux.s"
.include  "record-def.s"

#STACK LOCAL VARIABLES

.equ ST_WRITE_BUFFER,   8               #These are the function arguments
.equ ST_FILEDES,        12


.section .text

.globl write_record
.type write_record, @function

write_record:
  
