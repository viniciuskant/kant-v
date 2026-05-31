.section .text
.globl _start

_start:
    # I-Type
    addi x1, x2, 123
    addi x1, x2, -123
    lw   x3, 0(x4)
    lw   x3, 100(x4)
    lw   x3, -100(x4)
    jalr x1, x2, 0
    jalr x0, x1, 0
    
    # S-Type
    sw   x5, 8(x6)
    sh   x5, 10(x6)
    sb   x5, 12(x6)
    sw   x5, -8(x6)
    sh   x5, -10(x6)
    
    # B-Type
    beq  x7, x8, label_branch
    bne  x7, x8, label_branch
    blt  x7, x8, label_branch
    bge  x7, x8, label_branch
    bltu x7, x8, label_branch
    bgeu x7, x8, label_branch
    
    # U-Type
    lui  x9, 0x12345
    lui  x9, 0x80000
    lui  x9, 0x00001
    auipc x9, 0x12345
    auipc x9, 0x80000
    
    # J-Type
    jal  x10, label_jump
    jal  x0, label_jump
    
label_branch:
    # I-Type
    lb   x11, 0(x12)
    lh   x11, 0(x12)
    lbu  x11, 0(x12)
    lhu  x11, 0(x12)
    
    # I-Type
    slti x13, x14, 100
    sltiu x13, x14, 100
    andi x13, x14, 0xFF
    ori  x13, x14, 0xFF
    xori x13, x14, 0xFF
    slli x13, x14, 2
    srli x13, x14, 2
    srai x13, x14, 2
    
label_jump:
    nop
    ebreak                # breakpoint / end of program