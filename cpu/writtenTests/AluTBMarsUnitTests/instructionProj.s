addi $t1, $zero, 255
addi $t2, $zero, 105

subu $t4, $t1, $t2
sub $t3, $t1, $t2

addi $t3, $t4, -100


sub $t5, $t4, $t3
subu $t6, $t4, $t3



sw $t1, 268500992($zero)
lb $s0, 268500992($zero)
