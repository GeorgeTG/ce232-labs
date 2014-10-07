.data

.align 0
vector: .space 32
.align 0
vector1: .space 32

test_byte_array: .byte
'a','b','c','c','c','d','d','d','d','d','d','b','b','c','c','c','c','a','e','e','e','e','e','e','e','e','e','e','e','e','f', 0x1B
term_char: .byte 0x1B
new_line: .asciiz "New line"

.text
.globl main

main:


la $a0, test_byte_array
jal print_till_esc

la $v0, 4
la $a0, new_line
syscall

la $a1, vector
jal compress

la $a0, vector
jal print_compressed

la $a1, vector1
jal decompress

la $a0, vector1
jal print_till_esc

li $v0, 10
syscall

decompress:
#$t0 i
#$t1 j
#$t2 char count
#$t3 curr_char
#$t9 source
#$t8 dest

lb $t7, term_char
move $t8, $a1

li $t0, -1
main_loop:
addi $t0, $t0, 1
add $t9, $a0, $t0
lb $t3, ($t9)

beq $t3, $t7, dc_func
sb $t3, ($t8)
addi $t8, $t8, 1 #inc dest

j main_loop

dc_func:
addi $t0, $t0, 2 #make i skip compression stuff
addi $t9, $t9, 1
lb $t3, ($t9)

beq $t3, $t7, dc_ret #we found the esc char 2 times
addi $t9, $t9, 1
lb $t2, ($t9)

li $t1, -1
fill_bytes:
addi $t1, $t1, 1
beq $t1, $t2, main_loop

sb $t3, ($t8)
addi $t8, $t8, 1
j fill_bytes

dc_ret:
sb $t7, ($t8)
jr $ra




compress:
sub $sp, $sp, 8
sw $s0, 4($sp)
sw $s1, 0($sp)
lb $s0, term_char
#$a0 target, $a1 result
#$t9, source
move $t8,$a1# dest
li $t0, 0 # i
li $t1, 0 #j
#li $t2, 0 #k
#$s1 curr char

f1:
    add $t0, $t0, $t1  #inc i += j
    add $t9, $a0, $t0
    lb $s1, 0($t9) #s1 contains current char
    beq $s1, $s0, c_ret

    li $t1, 0
    count_loop:
        addi $t1, $t1, 1 #inc j
        add $t4, $t1, $t0
        add $t4, $a0, $t4
        lb $t4, 0($t4)
        beq $s1, $t4, count_loop

    bgt $t1, 3, do_compr

    li $t2, -1
    fill_loop:
        addi $t2, $t2, 1
        beq $t2, $t1, f1
        sb $s1, 0($t8)
        addi $t8, $t8, 1
    	j fill_loop

    do_compr:
    	sb $s0, 0($t8)
    	sb $s1, 1($t8)
    	sb $t1, 2($t8)
    	addi $t8, $t8, 3
    	j f1

c_ret:
sb $s0, 0($t8) #add escape at the end
sb $s0, 1($t8)

#---- restore saved regs------
lb $s1, 0($sp)
lb $s0, 4($sp)
addi $sp, $sp, 8
#-----------------------------

jr $ra

#----------- utils -----------------
print_till_esc:
	lb $t9, term_char
	move $t0, $a0 #keep adress in $t0
	pte_loop:
		lb $t1, 0($t0)
		beq $t1, $t9, end_pte

		li $v0, 11
		move $a0, $t1
		syscall #print one byte

		add $t0, $t0, 1
	j pte_loop

	end_pte:
	jr $ra

print_compressed:
lb $t9, term_char
move $t0, $a0 #keep adress in $t0

pc_loop:
	




