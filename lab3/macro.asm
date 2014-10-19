.macro print_int(%reg)
	move $a0, %reg
	li $v0, 1
	syscall
.end_macro

.macro print_str(%label)
	la $a0, %label
	li $v0, 4
	syscall
.end_macro

.macro get_int(%reg)
	li $v0, 5
	syscall
	move %reg, $v0
.end_macro