.include "macro.asm"

.data
prompt_msg: .asciiz "Give me a number [0 to terminate] : "
mem_error_msg: .asciiz "Memory allocation failed! Terminating!!!"
result_msg: .asciiz "List:( "
space: .asciiz " " #could be done with ascii of space char
parenth: .asciiz ")"

.text
.globl main


main:
#	$s0 head
	xor $s0, $s0, $s0
	
	LL:
		print_str(prompt_msg)
		get_int($t0)
		beqz $t0, LL_
		move $a0, $s0
		move $a1, $t0
		jal insertElement
		move $s0, $v0
		j LL
		
	LL_:
	print_str(result_msg)
	
	move $a0, $s0
	jal print_list
	
	print_str(parenth)
	li $v0, 10
	syscall

print_list:
#---------------function---------------
# $a0, node to print
#--------------------------------------
#----------stack---------
	sub $sp, $sp, 8
	sw $s0, 0($sp)
	sw $ra, 4($sp)
#------------------------
	move $s0, $a0
	beqz $s0, pl_ret
	lw $t0, 0($s0) #node->data
	print_int($t0)
	
	print_str(space)
	
	lw $a0, 4($s0) #node->next
	jal print_list
pl_ret:
#----------stack---------	
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	add $sp, $sp, 8
#------------------------
jr $ra

alloc_memory:
#---------------function---------------
# $a0, bytes to alloc
# ret: $v0, new block start adress
#--------------------------------------
	li $v0, 9
	syscall
	bnez $v0, am_ret
	
	print_str(mem_error_msg)
	li $v0, 10
	syscall
	
	am_ret:
jr $ra


insertElement:
#---------------function---------------
# $a0, list head
# $a1, data (word)
# ret: $v0, new head
#--------------------------------------

#-------------stack--------------------
	sub $sp, $sp, 16
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
#--------------------------------------
	move $s0, $a0
	move $s1, $a1
	
	bnez $s0, not_null
	#list is empty
	li $a0, 8
	jal alloc_memory
	sw $s1, 0($v0)
	xor $t0, $t0, $t0
	sw $t0, 4($v0)
	j ie_ret #v0 contains head's adress
	
	not_null:
	
	lw $t0, ($s0) #check if we have to replace head
	bge $s1, $t0, not_head
	
	li $a0, 8
	jal alloc_memory
	sw $s1, ($v0)
	sw $s0, 4($v0)
	j ie_ret #v0 contains new node's adress
	
	not_head:
	
	move $t0, $s0 #sNode = head 
	skip_loop:
		lw $t1, 4($t0) #sNode->next
		beqz $t1, sl_end #sNode == null
		lw $t2, 0($t1) #sNode->next->data
		bge $t2, $s1, sl_end # sNode->next->data >= data
		move $t0, $t1 #sNode = sNode -> next
		j skip_loop 
	sl_end:
	#insert after
	move $s2, $t0
	
	li $a0, 8
	jal alloc_memory
	sw $s1, 0($v0) #newNode->data = data
	lw $t0, 4($s2) #sNode->next
	sw $t0, 4($v0) #newNode->next = sNode->next
	sw $v0, 4($s2) #sNode->next = newNode
	move $v0, $s0
	ie_ret:
#-------------stack--------------------
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 16
#--------------------------------------

jr $ra
