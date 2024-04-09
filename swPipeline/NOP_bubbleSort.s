.data
array: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50
space: .asciiz " "

.text
.globl main
main:
    #la $s0, array # Load the address of the array into $s0
    lui $1, 0x00001001 #non psuedo
    ori $16, $1, 0x00000000
    addiu $8 $0, 0x00000000 #li $t0, 0      # Initialize i = 0
    addiu $9, $0, 0x00000000 #li $t1, 0      # Initialize j = 0
    addiu $17, $0, 0x0000000b #li $s1, 11     # Set the array length (11 elements)
    addiu $18, $0, 0x0000000b #li $s2, 11     # Initialize n-i for inner loop

    add $t2, $zero, $s0 # For iterating address by i
    add $t3, $zero, $s0 # For iterating address by j

    addi $s1, $s1, -1

outer_loop:
    addiu $9, $0 0x00000000 #li $t1, 0        # Reset j = 0
    addi $s2, $s2, -1 # Decrease size for inner_loop
    add $t3, $zero, $s0 # Reset address iteration for j
    nop
    nop
    nop
    nop

inner_loop:
    lw $s3, 0($t3) # Load array[j] into $s3
    addi $t3, $t3, 4 # Increment address for j
    nop
    nop
    nop
    nop
    lw $s4, 0($t3) # Load array[j+1] into $s4
    addi $t1, $t1, 1 # Increment j
    nop
    nop

    slt $t4, $s3, $s4 # Set $t4 = 1 if $s3 < $s4
    nop
    nop
    nop
    nop
    bne $t4, $zero, cond # If $s3 < $s4, skip swap

swap:
    sw $s3, 0($t3) # Swap array[j] and array[j+1]
    sw $s4, -4($t3)
    nop
    nop
    nop
    nop
    lw $s4, 0($t3)

cond:
    bne $t1, $s2, inner_loop # If j != n-i, continue inner loop

    addi $t0, $t0, 1 # Increment i
    nop
    nop
    nop
    nop
    bne $t0, $s1, outer_loop # If i != n, continue outer loop
    nop
    nop
    nop
    nop
    li $t0, 1

print_loop:
    addiu $2, $0, 0x00000001 #li $v0, 1
    lw $a0, 0($t2)
    nop
    nop
    syscall
    addiu $2, $0, 0x00000004 #li $v0, 4
    lui $1, 0x00001001 #la $a0, space
    ori $4, $1, 0x0000002c
    syscall

    addi $t2, $t2, 4 # Increment address for i
    addi $t0, $t0, 1 # Increment i
    nop
    nop
    nop
    nop
    bne $t0, $s1, print_loop # If i != n, continue print loop

exit:
    halt
