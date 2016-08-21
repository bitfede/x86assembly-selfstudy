#
# AUTHOR: Federico G. De Faveri
#
# PURPOSE: I wrote this script to automate the assembly and linking for the read-records program
#

as --32 readRecords.s -o readRecord.o
as --32 count-chars.s -o count-chars.o
as --32 write-newline.s -o write-newline.o
as --32 recordDiskReader.s -o recordDiskReader.o
ld -m elf_i386 readRecord.o count-chars.o write-newline.o recordDiskReader.o -o read-records
echo "Program Built! to execute run '$ ./read-records' ~~ REMEMBER: you need a test.dat file with a specific format!"
