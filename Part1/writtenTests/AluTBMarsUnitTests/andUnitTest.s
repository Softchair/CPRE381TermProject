#intitialise 

addi $t1, $zero, 1050
addi $t2, $zero, 92
addi $t3, $zero, -93204
addi $t4, $zero, -2349

# test cases

and $s0, $zero, $t1
and $s1, $t1, $t2
and $s2, $t1, $t1
and $s3, $t3, $t2,
and $s4, $t4, $t3

