.data
var1: .word 10
var2: .word 20
.text
main:
    la $t0, var1
    la $t1, var2
    beq $t0, $t1, equal
    bne $t0, $t1, not_equal
    j end
equal:
    # Code to execute if var1 equals var2
not_equal:
    # Code to execute if var1 does not equal var2
end:
    halt
