#
# AUTHOR: Jonathan Bartlett (Book Author)
#


.include  "linux.s"
.include  "record-def.s"

.section .data

#Constant data of the records we want to write
#each text ddata item si padded to the proper length with null (i.e. 0) bytes.

#.rept is used to pad each item. .rept tells the assembler to repeat the section between .rept
#and .endr the number of times specified. This is used in this program to add extra null
#characters at the end of this field to fill it up 

record1

.ascii      "Fredrick\0"
