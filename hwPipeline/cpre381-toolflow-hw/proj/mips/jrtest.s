.data
jump_address: .word jump_target
.text
main:
    la $t0, jump_address
    jr $t0
jump_target:
    halt
