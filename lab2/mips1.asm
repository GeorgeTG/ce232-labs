.data

.align 0
vector: .space 32

test_byte_array: .byte 
'a','b','c','c','c','d','d','d','d','d','d','b','b','c','c','c','c','a','e','e','e','e','e','e','e','e','e','e','e','e','f', 0x1B

term_char: .byte 0x1b

.text
.globl main

main:


la $a0, test_byte_array
jal print_till_esc


li $v0, 10
syscall








compress:
#$a0 target, $a1 result
move $s0, $a0
li $t0, 0



cmps_loop:



#----------- utils -----------------
print_till_esc:
lb $t9, term_char
move $t0, $a0 #keep adress in $t0
pte_loop:
lb $t1, 0($t0)
beq $t1, $t9, end_func

li $v0, 11
move $a0, $t1
syscall #print one byte

add $t0, $t0, 1
j pte_loop

end_func:
jr $ra