.globl _start

.section .text
_start:
    # Inicializacao de flags de sucesso
    addi x5, x0, 1          
    slt x3, x0, x1         
    slt x3, x1, x0       

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
    # TESTE 3: Operacoes Logicas e Branches Condicionais
    # ============================================================

    # XOR
    li   x1, 0x12345678     
    li   x2, 0x54321111     
    xor  x3, x1, x2
    li   x4, 0x46064769     
    bne  x3, x4, falha

    # OR
    or   x3, x1, x2   
    li   x4, 0x56365779     
    bne  x3, x4, falha

    # AND
    and  x3, x1, x2
    li   x4, 0x10301010     
    bne  x3, x4, falha

    # BLT (signed)
    li   x1, -5 
    li   x2, 3
    blt  x1, x2, blt_ok1
    j    falha
blt_ok1:
    li   x1, 5  #AQUI 1300ns
    li   x2, -3
    blt  x1, x2, falha

    # BGT via BLT (equivale a bgt x1, x2 => blt x2, x1)
    li   x1, 7
    li   x2, 2
    blt  x2, x1, bgt_ok1
    j    falha
bgt_ok1:
    li   x1, -1
    li   x2, 5
    blt  x2, x1, falha

    # BLTU (unsigned)
    li   x1, 1
    li   x2, 0x80000000
    bltu x1, x2, bltu_ok1
    j    falha
bltu_ok1:
    li   x1, 0x80000000
    li   x2, 1
    bltu x1, x2, falha

    # ============================================================
    # TESTE 4: Acessos Desalinhados e Sinais na Memoria
    # ============================================================
    addi x1, x0, 0x40       
    li   x2, 0xAABBCCDD     #case 2500ns
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
    jalr x0, 0(x1)    #3100ns      
    j falha
    
# FIM DO PROGRAMA – SUCESSO
falha:
    addi x5, x0, -1          # flag de falha

fim_sucesso:
trap:
    j trap                   # loop infinito