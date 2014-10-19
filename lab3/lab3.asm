.include "macro.asm"

.data
prompt_msg: .asciiz "What's size of the matrix? (N x N) "
matrix_get_start_msg: .asciiz "Please insert each entry of the matrix:\n"
not_symmetrical_msg: .asciiz "The matrix is NOT symmetrical!\n"
symmetrical_msg: .asciiz "The matrix IS symmetrical!\n"

.text
.globl main

main:
	print_str(prompt_msg)
	get_int($s0) #keep matrix size

	mul $a0, $v0, $v0 # need n^2 
	mul $a0, $a0, 4 # those are integers
  
 #alloc memory 
	li $v0, 9 #sbrk (heap alloc)
	syscall
	move $s1, $v0 #store address of allocated memory

	print_str(matrix_get_start_msg)

	move $a0, $s1
	move $a1, $s0
	jal get_sq_matrix

	move $a0, $s1
	move $a1, $s0
	jal is_matrix_symmetrical

	bgtz $v0, print_sym
	print_str(not_symmetrical_msg)
	j exit

	print_sym:
	print_str(symmetrical_msg)

	exit:
		li $v0, 10
		syscall


####### function #########
is_matrix_symmetrical:
#$a0, start of matrix
#$a1, N (size)

#------stack-------
sub $sp, $sp, 12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $ra, 8($sp)
#------------------

move $s0,$a0
move $s1,$a1
 
li $t0, -1
FF1:
	addi $t0, $t0, 1
	beq $t0, $s1, success
	
	li $t1, -1
	FF2:
		add	$t1, $t1, 1		
		beq $t1, $s1, FF1
		beq $t0, $t1, FF2 #skip main diagonal's entries
		
		move $a0, $s0
		move $a1, $t0
		move $a2, $t1
		move $a3, $s1
		jal get_entry
		move $t2, $v0 # [i,j]
		
		move $a0, $s0
		move $a1, $t1
		move $a2, $t0
		move $a3, $s1
		jal get_entry	#[j,i]
		bne $t2, $v0, fail #if [j,i] != [i,j] at least once, the matrix is not sym.
		
		j FF2

success:
	li $v0, 1
	j f_ret
fail:
	li $v0, 0
	
f_ret:
#------stack-------
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
add $sp, $sp, 12
#------------------

jr $ra


.include "matrix_toolbox.asm"
	
