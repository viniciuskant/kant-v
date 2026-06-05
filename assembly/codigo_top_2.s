.globl _start

.section .text
_start:
    # 1. INSTRUÇÕES IMEDIATAS (Tipo-I) e Inicialização
    addi x1, x0, 10 # x1 = 0 + 10  -> Esperado: x1 = 10 (0x0A)
    addi x2, x0, -5 # x2 = 0 + (-5)-> Esperado: x2 = -5 (0xFFFFFFFB)
    andi x3, x1, 7 # x3 = 10 & 7  -> Esperado: x3 = 2  (0x02)
    ori  x4, x1, 5 # x4 = 10 | 5  -> Esperado: x4 = 15 (0x0F)
    xori x5, x1, -1 # x5 = 10 ^ -1 -> Esperado: x5 = -11 (0xFFFFFFF5)
    slli x6, x1, 2 # x6 = 10 << 2 -> Esperado: x6 = 40 (0x28)
    srli x7, x1, 1 # x7 = 10 >> 1 -> Esperado: x7 = 5  (0x05)
    
    # 2. INSTRUÇÕES REGISTRADOR-REGISTRADOR (Tipo-R)
    add  x8, x1, x2 # x8 = 10 + (-5)-> Esperado: x8 = 5 (0x05)
    sub  x9, x1, x2 # x9 = 10 - (-5)-> Esperado: x9 = 15 (0x0F)
    and  x10, x1, x4 # x10 = 10 & 15 -> Esperado: x10 = 10 (0x0A)
    or   x11, x1, x2 # x11 = 10 | -5 -> Esperado: x11 = -5 (0xFFFFFFFB)
    xor  x12, x1, x1 # x12 = 10 ^ 10 -> Esperado: x12 = 0 (0x00)
    sll  x13, x1, x3 # x13 = 10 << 2 -> Esperado: x13 = 40 (0x28)
    srl  x14, x6, x3 # x14 = 40 >> 2 -> Esperado: x14 = 10 (0x0A)
    sra  x15, x2, x3 # x15 = -5 >> 2 (aritmético) -> Esperado: x15 = -2 (0xFFFFFFFE)

    # 3. COMPARAÇÕES (SLT / SLTI)
    slt  x16, x2, x1 # -5 < 10 (com sinal)   -> Esperado: x16 = 1
    sltu x17, x2, x1 # -5 < 10 (sem sinal / 0xFFFFFFFB > 0x0A) -> Esperado: x17 = 0
    slti x18, x2, 0 # -5 < 0 (com sinal)    -> Esperado: x18 = 1

    # 4. CARREGAMENTO DE IMEDIATOS GRANDES (LUI / AUIPC)
    lui  x19, 0x12345 # x19 = depende do PC atual.
    auipc x20, 0x20 # x20 = PC + 0x20000 -> Esperado: PC_atual + 0x20000

    # 5. ACESSO À MEMÓRIA (Tipo-S e Tipo-I de Load)
    addi x21, x0, 0x20 # x21 será nosso endereço base para escrita (ex: 0x20)
    addi x22, x0, 0x55   # Valor de teste 1
    
    sb   x22, 0(x21) # Salva byte 0x55 no endereço 0x20
    sh   x22, 2(x21) # Salva half-word 0x0055 no endereço 0x22
    sw   x22, 4(x21) # Salva word 0x00000055 no endereço 0x24

    lb   x23, 0(x21) # Carrega byte -> Esperado: x23 = 0x55
    lh   x24, 2(x21) # Carrega half-word -> Esperado: x24 = 0x0055
    lw   x25, 4(x21) # Carrega word -> Esperado: x25 = 0x00000055
    
    # Teste de extensão de sinal em loads menores
    addi x26, x0, -0x7F # x26 = 0xFFFFFF81
    sb   x26, 8(x21) # Salva o byte 0x81 no endereço 0x28
    lb   x27, 8(x21) # Carrega com sinal -> Esperado: x27 = 0xFFFFFF81 (-127)
    lbu  x28, 8(x21) # Carrega sem sinal -> Esperado: x28 = 0x00000081 (129)

    # 6. TESTES CONDICIONAIS (Tipo-B)
    beq  x1, x1, teste_bne  # 10 == 10? Deve desviar.
    addi x29, x0, 99 # Se falhar e passar direto, x29 muda (ERRO)

teste_bne:
    bne  x1, x2, teste_blt # 10 != -5? Deve desviar.
    addi x29, x0, 99 # Se falhar, x29 muda (ERRO)

teste_blt:
    blt  x2, x1, teste_bge # -5 < 10? Deve desviar.
    addi x29, x0, 99 # Se falhar, x29 muda (ERRO)

teste_bge:
    bge  x1, x2, teste_bltu # 10 >= -5? Deve desviar.
    addi x29, x0, 99 # Se falhar, x29 muda (ERRO)

teste_bltu:
    bltu x1, x2, teste_bgeu # 10 < -5 (sem sinal: 10 < 4294967291)? Deve desviar.
    addi x29, x0, 99 # Se falhar, x29 muda (ERRO)

teste_bgeu:
    bgeu x2, x1, fim_salto # -5 >= 10 (sem sinal: 4294967291 >= 10)? Deve desviar.
    addi x29, x0, 99 # Se falhar, x29 muda (ERRO)

fim_salto:
    # Se x29 é sendo 0, significa que todos os testes condicionais funcionaram funcionaram!

    # 7. SALTOS INCONDICIONAIS (JAL / JALR)
    jal  x30, alvo_jal      # Pula para alvo_jal. Salva PC+4 em x30.
    addi x29, x0, 99        # Linha pulada.

alvo_jal: # x30 deve conter o endereço da instrução 'addi x29, x0, 99' acima.
    la   x31, alvo_jalr # Carrega o endereço do rótulo em x31 (usa auipc/addi)
    jalr x0, 0(x31) # Pula para o endereço em x31. x0 ignora o retorno.
    addi x29, x0, 99 # Linha pulada.

alvo_jalr:

trap:
    j trap