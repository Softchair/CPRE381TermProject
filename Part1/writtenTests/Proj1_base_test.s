.data
    # Data section for storing values
    value1: .word 10
    value2: .word 20
    result: .word 0

.text
.globl main
main:
    # Load values into registers
    lw $t0, value1
    lw $t1, value2

    # Arithmetic instructions
    add $t2, $t0, $t1       # add
    addi $t3, $t0, 5        # addi
    addiu $t4, $t0, 10      # addiu
    addu $t5, $t0, $t1      # addu
    sub $t6, $t0, $t1       # sub
    subu $t7, $t0, $t1      # subu
    slt $t8, $t0, $t1       # slt
    slti $t9, $t0, 15       # slti
    sll $s0, $t0, 2         # sll
    srl $s1, $t0, 2         # srl
    sra $s2, $t0, 2         # sra
    sllv $s3, $t0, $t1      # sllv
    srlv $s4, $t0, $t1      # srlv
    srav $s5, $t0, $t1      # srav

    # Logical instructions
    and $s6, $t0, $t1       # and
    andi $s7, $t0, 0xFF     # andi
    or $s8, $t0, $t1        # or
    ori $s9, $t0, 0xFF      # ori
    xor $s10, $t0, $t1      # xor
    xori $s11, $t0, 0xFF    # xori
    nor $s12, $t0, $t1      # nor
    lui $s13, 0x1234        # lui

    # Store result
    sw $t2, result

    # Branch instructions
    beq $t0, $t1, equal     # beq
    bne $t0, $t1, notEqual # bne
    j end                   # j
    jal end                 # jal
    jr $ra                 # jr

equal:
    # Equal branch
    add $s14, $t0, $t1

notEqual:
    # Not equal branch
    sub $s15, $t0, $t1

end:
    # End of program
    halt
