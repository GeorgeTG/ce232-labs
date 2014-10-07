#lab 1 count 1s in a positive integer given by user
#George T. Gougoudis 1769
#Inf uth 2014

.data
get_input_str: .asciiz "Give me a positive integer:\n"
result_str: .asciiz "Number "
result_str1: .asciiz " has "
result_str2: .asciiz " ones!\n"

.text
.globl main 

main:

#Hammin weigth algorithm
# http://en.wikipedia.org/wiki/Hamming_weight

#------------------------constants-------------------------
# We will be using lui to load the higher 16 bits first,
# then use OR to set the lower ones
lui $t5, 0x5555 #binary 01010101
ori $t5, 0x5555

lui $t6, 0x3333 #binary 00110011
ori $t6, 0x3333

lui $t7, 0x0f0f #binary 00001111
ori $t7, 0x0f0f

lui $t8, 0x0101 #sum of 256 to the power of 0,1,2...
ori $t8, 0x0101
#-----------------------------------------------------------

#read integer from user
li $v0,4 #print string

la $a0,get_input_str
syscall

li $v0, 5
syscall

move $s2, $v0 #keep the number

srl $t0, $v0, 1
and $t0, $t0, $t5
sub $v0, $v0, $t0

srl $t0, $v0, 2
and $t0, $t0, $t6
and $t1, $v0, $t6
add $v0, $t0, $t1

srl $t0, $v0, 4
add $t0, $v0, $t0
and $v0, $t0, $t7

mul $v0, $v0, $t8
srl $s1, $v0, 24
#done

#print result


la $a0, result_str
jal print_string

move $a0, $s2
jal print_int

la $a0, result_str1
jal print_string

move $a0, $s1
jal print_int

la $a0, result_str2
jal print_string

li $v0, 10
syscall

print_string:
li $v0, 4 #print string
syscall
jr $ra #jump to jal stored program counter

print_int:
li $v0, 1 #print int
syscall
jr $ra
