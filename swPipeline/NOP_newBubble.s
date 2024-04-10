.data
array1: .word 123, 111, 44, 101, 2, 1, 99
size:.word  40

.text
.globl main

main:
lui $at, 4097

lw $t3, size

addi $t1, $0, 0
addi $t2, $0, 0

ori $t0, $at, 0
nop

j count
nop
nop

swap:
	sw $s0, 4($t4)		# swap
	sw $s1, 0($t4)
	j sort1_1
	nop
	nop

count:
	sort:
		add $t4, $t0, $t1
		nop
		nop
		nop
		lw $s0, 0($t4)
		lw $s1, 4($t4)
		nop
		nop
		nop
		slt $t5, $s1, $s0
		nop
		nop
		nop
		bne $t5, $0, swap
		nop
		nop

		sort1_1:
		addi $t1, $t1, 4
		nop
		nop
		nop
		addi $t6, $t1, 4
		sub $t7, $t3, $t2
		nop
		nop
		nop
		slt $s2, $t6, $t7
		nop
		nop
		nop
		bne $s2, $0, sort
		nop
		nop
	addi $t2, $t2, 4
	addi $t1, $0, 0
	nop
	nop
	slt $s3, $t2, $t3
	nop
	nop
	nop
	bne $s3, $0, count
	nop
	nop


addi  $2,  $0,  10              # Place 10 in $v0 to signal a halt
halt