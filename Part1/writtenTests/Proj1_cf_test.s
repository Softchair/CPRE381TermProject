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
    jal function1

    halt

function1:
    # Function 1
    add $t2, $t0, $t1       # Demonstrate arithmetic operation

    # Call function2
    jal function2

    # Return from function1
    jr $ra

function2:
    # Function 2
    beq $t0, $t1, equal     # Demonstrate branch instruction
    bne $t0, $t1, notEqual # Demonstrate branch instruction

    # Call function3
    jal function3

    # Return from function2
    jr $ra

equal:
    # Equal branch
    add $t3, $t0, $t1

notEqual:
    # Not equal branch
    sub $t4, $t0, $t1

function3:
    # Function 3
    j end                   # Demonstrate jump instruction

    # Call function4
    jal function4

    # Return from function3
    jr $ra

function4:
    # Function 4
    jal end                 # Demonstrate jump and link instruction

    # Return from function4
    jr $ra

end:
    # End of program
    halt
