.globl _start

.section .text
_start:
    # Inicializacao de flags de sucesso
    addi x5, x0, 1          

    # ============================================================
    # TESTE 1: Extensao de Sinal e Limites de Imediados
    # ============================================================
    addi x1, x0, -1         
    addi x2, x0, 2047       
    
    # Verificar se -1 + 2047 = 2046
    addi x3, x1, 2047       
    addi x4, x0, 2046
    bne  x3, x4, falha      

    # Teste de SLTI/SLTIU com bordas
    slti  x3, x1, 0         
    beq   x3, x0, falha
    sltiu x3, x1, 1         
    bne   x3, x0, falha

    # ============================================================
    # TESTE 2: Shifts Imediatos
    # ============================================================
    addi x1, x0, 0xF0       
    slli x2, x1, 4          
    li   x3, 0xF00          
    bne  x2, x3, falha

    # Teste de SRLI
    addi x1, x0, -1         
    srli x2, x1, 16         
    lui  x3, 0x00010        
    addi x3, x3, -1         
    bne  x2, x3, falha

    # Teste de SRAI
    addi x1, x0, -16        
    srai x2, x1, 2          
    addi x3, x0, -4
    bne  x2, x3, falha

    # ============================================================
    # TESTE 3: Operacoes Logicas Complexas
    # ============================================================
    li   x1, 0x12345678     
    li   x2, 0x54321111     

    # XOR
    xor  x3, x1, x2
    li   x4, 0x46064769     
    bne  x3, x4, falha

    # ============================================================
    # TESTE 4: Acessos Desalinhados e Sinais na Memoria
    # ============================================================
    addi x1, x0, 0x40       
    li   x2, 0xAABBCCDD     
    sw   x2, 0(x1)          

    # Testar LB
    lb   x3, 0(x1)          
    li   x4, 0xFFFFFFDD     
    bne  x3, x4, falha

    # Testar LBU
    lbu  x3, 0(x1)          
    addi x4, x0, 0xDD
    bne  x3, x4, falha

    # Testar LH
    lh   x3, 0(x1)          
    li   x4, 0xFFFFCCDD     
    bne  x3, x4, falha

    # Testar LHU
    lhu  x3, 0(x1)          
    li   x4, 0x0000CCDD     
    bne  x3, x4, falha

    # ============================================================
    # TESTE 5: Saltos e Linkagem
    # ============================================================
    jal  x1, funcao_teste   
    
retorno_funcao:
    la   x2, fim_sucesso
    jalr x0, 0(x2)          

funcao_teste:
    jalr x0, 0(x1)          
    j falha

    # ============================================================
    # TESTE 6: Branch condicional – ambos os caminhos
    # (exercita “falha e não” – ou seja, tanto o branch tomado
    # quanto o não tomado são percorridos)
    # ============================================================
    addi x10, x0, 5         # valor de referência
    addi x11, x0, 5
    beq  x10, x11, branch_tomado   # igual -> branch tomado
    j    branch_nao_tomado          # não deve ocorrer
branch_tomado:
    # Simula sucesso parcial: apenas continua
    addi x12, x0, 1
    j    continua_branch
branch_nao_tomado:
    # Se cair aqui, falha porque deveria ter tomado o branch
    j    falha
continua_branch:
    # Agora teste com valores diferentes
    addi x10, x0, 5
    addi x11, x0, 7
    bne  x10, x11, branch_diferente  # diferente -> tomado
    j    falha                        # se cair aqui, erro
branch_diferente:
    addi x12, x0, 2
    # Nenhuma falha até aqui

    # ============================================================
    # TESTE 7: Loop com 256 posições de memória usando somas da ALU
    # Escreve valores = i + (i << 1) + 5  (ou seja, 3*i + 5)
    # nas 256 words a partir do endereço 0x1000, depois lê e verifica.
    # Utiliza operações: addi, slli, add (soma de operadores da ALU)
    # ============================================================
    li   x13, 0x1000         # endereço base
    addi x14, x0, 0          # contador i (0 a 255)

loop_escrita:
    # Calcula valor = (i << 1) + i + 5  (i*3 + 5)
    slli x15, x14, 1         # x15 = i * 2
    add  x15, x15, x14       # x15 = i*2 + i = i*3
    addi x15, x15, 5         # x15 = i*3 + 5
    sw   x15, 0(x13)         # escreve na memória
    addi x13, x13, 4         # próximo endereço (word)
    addi x14, x14, 1         # i++
    addi x16, x0, 256
    bne  x14, x16, loop_escrita

    # Verificação: lê e compara com o mesmo cálculo
    li   x13, 0x1000
    addi x14, x0, 0

loop_verifica:
    # Recalcula o valor esperado (i*3 + 5)
    slli x15, x14, 1
    add  x15, x15, x14
    addi x15, x15, 5
    lw   x17, 0(x13)         # valor lido da memória
    bne  x17, x15, falha     # se diferente, falha
    addi x13, x13, 4
    addi x14, x14, 1
    addi x16, x0, 256
    bne  x14, x16, loop_verifica

    # ============================================================
    # TESTE 8: Armazenamento e carga com desalinhamento (SH, SB)
    # ============================================================
    addi x1, x0, 0x80        # endereço base
    li   x2, 0xAABBCCDD
    sw   x2, 0(x1)           # palavra alinhada

    # Testa SH (store half) desalinhado em +2
    li   x2, 0x1122
    sh   x2, 2(x1)           # escreve 0x1122 no deslocamento 2
    lhu  x3, 2(x1)           # carrega half desalinhado
    li   x4, 0x1122
    bne  x3, x4, falha

    # Testa SB (store byte) em +1
    li   x2, 0x99
    sb   x2, 1(x1)           # escreve 0x99 no deslocamento 1
    lbu  x3, 1(x1)
    li   x4, 0x99
    bne  x3, x4, falha

    # Testa LB com extensão de sinal a partir do mesmo local
    lb   x3, 1(x1)           # 0x99 (positivo, pois <128)
    li   x4, 0x99
    bne  x3, x4, falha

    # Testa LH desalinhado com extensão de sinal (meia palavra em 0x80+2=0x82)
    lh   x3, 2(x1)           # 0x1122 -> positivo
    li   x4, 0x1122
    bne  x3, x4, falha

# FIM DO PROGRAMA – SUCESSO
falha:
    addi x5, x0, -1          # flag de falha

fim_sucesso:
trap:
    j trap                   # loop infinito