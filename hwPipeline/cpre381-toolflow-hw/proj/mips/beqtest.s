.data
var1: .word 10
var2: .word 10
.text
main:
    la $t0, var1
    la $t1, var2
    beq $t0, $t1, equal
    j end
equal:
    # Code to execute if var1 equals var2
end:
    halt
