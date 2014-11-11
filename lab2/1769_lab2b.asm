


.text
.globl main

main:

#bner $s0, $t0, $t1
beq $s0, $t0, LL
jr $t1
LL:

#li $s0, 0xA3476678
#li $t0, 0xBB110011
#interleave $t1, $s0, $t0

lui $v0, 0x5555
ori $v0, 0x5555
and $v1, $v0, $s0

lui $v0, 0xAAAA
ori $v0, 0xAAAA
and $v0, $v0, $t0

or $t1, $v1, $v0
