.globl _start

.section .text
_start:
# Inicializacao de flags de sucesso
addi x5, x0, 1 #ao final x5 igual a 1 não terminou, -1 é erro e 5 terminou com sucesso
slt x3, x0, x1
slt x3, x1, x0

# TESTE 1: Extensao de Sinal e Limites de Imediados
addi x1, x0, -1
addi x2, x0, 2047
addi x3, x1, 2047
addi x4, x0, 2046
bne x3, x4, falha
slti x3, x1, 0
beq x3, x0, falha
sltiu x3, x1, 1
bne x3, x0, falha

# TESTE 2: Shifts Imediatos
addi x1, x0, 0xF0
slli x2, x1, 4
li x3, 0xF00
bne x2, x3, falha
addi x1, x0, -1
srli x2, x1, 16
lui x3, 0x00010
addi x3, x3, -1
bne x2, x3, falha
addi x1, x0, -16
srai x2, x1, 2
addi x3, x0, -4
bne x2, x3, falha

# TESTE 3: LUI e AUIPC
lui x1, 0x12345
li x2, 0x12345000
bne x1, x2, falha
auipc x3, 0
auipc x4, 0
sub x4, x4, x3
addi x1, x0, 4
bne x4, x1, falha

# TESTE 4: Operacoes Aritmeticas (ADD, SUB, SLT, SLTU)
li x1, 0x7FFFFFFF
li x2, 1
add x3, x1, x2
lui x4, 0x80000
bne x3, x4, falha
li x1, 0x80000000
li x2, 1
sub x3, x1, x2
li x4, 0x7FFFFFFF
bne x3, x4, falha
li x1, -5
li x2, 3
slt x3, x1, x2
addi x4, x0, 1
bne x3, x4, falha
slt x3, x2, x1
bne x3, x0, falha
li x1, -1
li x2, 1
sltu x3, x1, x2
bne x3, x0, falha
sltu x3, x2, x1
addi x4, x0, 1
bne x3, x4, falha

# TESTE 5: Shifts Variaveis (SLL, SRL, SRA)
li x1, 0x0000F0F0
addi x2, x0, 8
sll x3, x1, x2
li x4, 0x00F0F000
bne x3, x4, falha
li x1, 0xF0F00000
srl x3, x1, x2
li x4, 0x00F0F000
bne x3, x4, falha
li x1, 0xF0F00000
sra x3, x1, x2
li x4, 0xFFF0F000
bne x3, x4, falha

# TESTE 6: Operacoes Logicas Imediatas (XORI, ORI, ANDI)
li x1, 0x12345678
xori x2, x1, 0x0FF
li x3, 0x12345687
bne x2, x3, falha
ori x2, x1, 0x0FF
li x3, 0x123456FF
bne x2, x3, falha
andi x2, x1, 0x0F0
li x3, 0x00000070
bne x2, x3, falha

# TESTE 7: Operacoes Logicas com Registradores (XOR, OR, AND)
li x1, 0x12345678
li x4, 0x000000FF
xor x2, x1, x4
li x3, 0x12345687
bne x2, x3, falha
or x2, x1, x4
li x3, 0x123456FF
bne x2, x3, falha
and x2, x1, x4
li x3, 0x00000078
bne x2, x3, falha

# TESTE 8: Branches Condicionais (BEQ, BNE, BGE, BGEU, BLT, BLTU)
li x1, 42
li x2, 42
beq x1, x2, beq_ok1
j falha
beq_ok1:
li x1, 42
li x2, 0
beq x1, x2, falha
li x1, 5
li x2, 6
bne x1, x2, bne_ok1
j falha
bne_ok1:
li x1, 5
li x2, 5
bne x1, x2, falha
li x1, 7
li x2, 3
bge x1, x2, bge_ok1
j falha
bge_ok1:
li x1, -2
li x2, 5
bge x1, x2, falha
li x1, -5
li x2, -5
bge x1, x2, bge_ok2
j falha
bge_ok2:
li x1, 0x80000000
li x2, 0x7FFFFFFF
bge x1, x2, falha
li x1, 1
li x2, 0x80000000
bgeu x1, x2, falha
li x1, 0xFFFFFFFF
li x2, 1
bgeu x1, x2, bgeu_ok1
j falha
bgeu_ok1:
li x1, 0
li x2, 0
bgeu x1, x2, bgeu_ok2
j falha
bgeu_ok2:
li x1, -5
li x2, 3
blt x1, x2, blt_ok1
j falha
blt_ok1:
li x1, 7
li x2, 2
blt x1, x2, falha
li x1, 5
li x2, 10
bltu x1, x2, bltu_ok1
j falha
bltu_ok1:
li x1, -1
li x2, 1
bltu x1, x2, falha

# TESTE 9: Operacoes de Memoria (SB, SH, LB, LBU, LH, LHU, LW)
addi x1, x0, 0x50
li x2, 0xDEADBEEF
sw x2, 0(x1)
addi x3, x0, 0xAB
sb x3, 0(x1)
lb x4, 0(x1)
li x6, 0xFFFFFFAB
bne x4, x6, falha
lbu x4, 0(x1)
li x6, 0xAB
bne x4, x6, falha
li x3, 0x1234
sh x3, 0(x1)
lh x4, 0(x1)
li x6, 0x00001234
bne x4, x6, falha
li x3, 0x8765
sh x3, 2(x1)
lh x4, 2(x1)
li x6, 0xFFFF8765
bne x4, x6, falha
lhu x4, 2(x1)
li x6, 0x00008765
bne x4, x6, falha
li x3, 0xCAFEBABE
sw x3, 0(x1)
lw x4, 0(x1)
bne x4, x3, falha

# TESTE 10: JALR com link e retorno
la x1, alvo_jalr
jalr x2, x1, 0
j falha
alvo_jalr:
auipc x3, 0
addi x3, x3, 4
bne x2, x0, jalr_ok
j falha
jalr_ok:

# TESTE 11: Verificacao do registrador zero (x0)
addi x0, x0, 99
add x1, x0, x0
bne x1, x0, falha

# TESTE  ORIGINAL: Acessos Desalinhados e Sinais na Memoria
addi x1, x0, 0x40
li x2, 0xAABBCCDD
sw x2, 0(x1)
lb x3, 0(x1)
li x4, 0xFFFFFFDD
bne x3, x4, falha
lbu x3, 0(x1)
addi x4, x0, 0xDD
bne x3, x4, falha
lh x3, 0(x1)
li x4, 0xFFFFCCDD
bne x3, x4, falha
lhu x3, 0(x1)
li x4, 0x0000CCDD
bne x3, x4, falha

jal x1, funcao_teste
retorno_funcao:
la x2, fim_sucesso
jalr x0, 0(x2)
funcao_teste:
jalr x0, 0(x1)
j falha

falha:
addi x5, x0, -1
fim_sucesso:
trap:
addi x5, x0, 5
j trap