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

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# Options for open

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101
