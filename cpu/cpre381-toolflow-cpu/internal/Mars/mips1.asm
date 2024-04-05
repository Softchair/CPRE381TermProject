.data
    # Data section for storing values
    value1: .word 10
    value2: .word 20

.text
.globl main
main:
    # Load values into registers
    lw $t0, value1
    lw $t1, value2

    # Call function1
    jal function4
    
    j end

function1:
    # Function 1
    add $t2, $t0, $t1       # Demonstrate arithmetic operation

    # Call function2
    jr $ra

function2:
    # Function 2
    add $t3, $t0, $t1       # Demonstrate arithmetic operation

    # Call function3
    j function1


function3:
    add $t2, $t0, $t1       # Demonstrate arithmetic operation

    # Function 3
    j function2                   # Demonstrate jump instruction


function4:
    add $t3, $t0, $t1       # Demonstrate arithmetic operation
    # Function 4
    j function3


end:
    # End of program
    halt