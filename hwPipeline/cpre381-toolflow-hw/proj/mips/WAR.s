# Program to test WAR hazard
add $t0, $t1, $t2   # $t0 = $t1 + $t2
sub $t0, $t0, $t4   # $t0 = $t0 - $t4
halt
