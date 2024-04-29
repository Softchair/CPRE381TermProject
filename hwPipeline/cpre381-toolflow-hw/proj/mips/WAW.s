# Program to test WAW hazard
add $t0, $t1, $t2   # $t0 = $t1 + $t2
add $t0, $t3, $t4   # $t0 = $t3 + $t4
halt
