#Pipelined design Instruction Test
.data
array: .word
.text



addi $t1, $0, 100
addi $t2, $0, 10
nop
nop
nop
add $t3, $t2, $t1 #$t3 = 10
addiu $t4, $0, 40
nop
nop
nop
addu $s0, $t4, $t3 #s0 = 50
nop
nop
nop
andi $t1, $s0, 50 #t1 = 50
lasw $s7, array
or $t2, $t3, $t4
nop
and $t0, $t1, $s0 #t0 = 50
lui $t1, 2000
nop
nop
sw $t0, 0($s7)
nor $t2, $t1, $t0
xor $t3, $t1, $t0
xori $t0, $t0, 50
ori $t5, $t1, 5000
slt $t8, $t2, $t3
slti $s2, $t1, 55 #1 
lw $s3, 0($s7)
sll $t0, $t1, 4
nop
nop
nop
srl $t1, $t0, 4
nop
nop
nop
sra $t9 $t0, 1
sub $t5, $t5, $t1
subu $t6, $t3, $t2
j jump
nop

jump:

lui $s3 ,64
nop
nop
nop
add $s4, $s3, 224
nop
nop
nop
jr $s4


jumpadd:
nop
lb $t1, 0($s7)
lh $t2, 0($s7)
lbu $t3, 0($s7)
lhu $t4, 0($s7)

sllv $t1, $s3, $t1
srlv $t2, $t2, $t3
nop
nop
nop
srav $t3, $t1, $t2
nop
nop
nop

addi $t1, $t0, 1
nop
nop
nop
bne $t1, $t8, yeah
nop
#bne
#beq


yeah:
beq $t1, $t8, leave
nop

leave:
halt

