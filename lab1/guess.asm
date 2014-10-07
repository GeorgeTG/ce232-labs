#lab 1 guess number game
#George T. Gougoudis 1769
#Inf uth 2014

.data
welcome_str: .asciiz "Try to guess which number between 0 and 100 i am thinking of!\n"
give_int_str: .asciiz "Please give an integer:\n"
too_small_str: .asciiz "Too small!"
too_big_str: .asciiz "Too big!"
far_away_str: .asciiz " But you are far away!\n"
close_str: .asciiz " But you are close!\n"
very_close_str: .asciiz " But you are very close!\n"
success_str: .asciiz "You guessed it with "
success_str1: .asciiz " tries!\n"

.text
.globl main

main:
li $v0, 30 #get time in ms since the epoch
syscall #$a0 low order, $a1 high order

li $v0, 40 #set seed
move $a1, $a0 #move low order of time in $a1
li $a0, 0 #we want to set the seed of the first generator
syscall

li $v0, 42 #random generator with range
li $a1, 100 #upper bound 
li $a0, 0 #use the first generator
syscall

move $t5, $a0 #generated number returned in a0

#--test
#move $a0, $t5
#jal print_int
#----

li $t6, 1 #init counter

la $a0, welcome_str
jal print_string

loop:
la $a0, give_int_str
jal print_string

li $v0, 5 #read int
syscall

#find distance between generated and given number
sub $t0, $v0, $t5

beqz $t0, found

addi $t6, $t6, 1 #inc counter

bgez $t0, too_big #determine whether given number is too big or too small

la $a0, too_small_str
j find_distance

too_big:
la $a0, too_big_str

find_distance:
jal print_string

abs $v0, $t0

bge $v0, 25, ge25
bge $v0, 10, ge10


la $a0, very_close_str
jal print_string

j loop

ge10:
la $a0, close_str
jal print_string

j loop

ge25:
la $a0, far_away_str
jal print_string

j loop

found:
la $a0, success_str
jal print_string

move $a0, $t6
jal print_int

la $a0, success_str1
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
