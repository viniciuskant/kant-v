    .text
    .globl _start

_start:
    # Base da RAM
    li x1, 0x08

    # Inicializa valores
    li x2, 10
    li x3, 20

    # ALU
    add x4, x2, x3 # 30
    sub x5, x3, x2 # 10
    and x6, x2, x3
    or  x7, x2, x3
    xor x8, x2, x3

    # Store
    sw x4, 0(x1)
    sw x5, 4(x1)
    sw x6, 8(x1)
    sw x7, 12(x1)
    sw x8, 16(x1)

    # Load
    lw x9, 0(x1)
    lw x10, 4(x1)

    # Dependência
    add x11, x9, x10

    # Branch tomado
    beq x11, x4, equal

    li x12, 0xdead
    jal x0, done

equal:
    li x12, 0xbeef

    # Loop
    li x13, 5

loop:
    addi x13, x13, -1
    bne x13, x0, loop

done:
    sw x12, 20(x1)

halt:
    jal x0, halt