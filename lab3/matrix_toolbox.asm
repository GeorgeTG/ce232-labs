
.data
matrix_get_entry_msg: .asciiz "Entry ["
matrix_get_entry_msg1: .asciiz ","
matrix_get_entry_msg2: .asciiz "]:"

.text

####### function #########
get_sq_matrix:
#a0 adress
#a1 N (size)

#$t0 i
#$t1 j
#s0, adress
#s1, N (size)

#------stack-------
sub $sp, $sp, 12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $ra, 8($sp)
#------------------

move $s0, $a0
move $s1, $a1

li $t0, -1
F1:
	addi $t0, $t0, 1
	beq $t0, $s1, f1
	
	li $t1, -1
	F2:
		add	$t1, $t1, 1		
		beq $t1, $s1, F1
		
	 	print_str(matrix_get_entry_msg)
	 	print_int($t0)
	 	
	    print_str(matrix_get_entry_msg1)
	 	print_int($t1)
	 	
	 	print_str(matrix_get_entry_msg2)
	 
	    get_int($t2) #keep number
	  
	    move $a0, $s0
	    move $a1, $t0
	    move $a2, $t1
	    move $a3, $s1
	    jal get_entry_address
	    
	    sw $t2, ($v0)
	    
	    j F2
	    
f1: 
#------stack-------
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
add $sp, $sp, 12
#------------------

jr $ra


####### function #########
get_entry:
#a0 matrix first entry [0,0]
#a1, i
#a2, j
#a3, N
#------stack-------
sub $sp, $sp, 4
sw $ra, 0($sp)
#------------------

jal get_entry_address
lw $v0, ($v0)

#------stack-------
lw $ra, 0($sp)
add $sp, $sp, 4
#------------------
jr $ra


####### function #########
get_entry_address:
#a0 matrix first entry [0,0]
#a1, i
#a2, j
#a3, N

mul $v0, $a1, $a3 #v0 =i*N
add $v0, $v0, $a2 #v0 += j
mul $v0, $v0, 4 #v0 *= 4

add $v0, $v0, $a0

jr $ra
