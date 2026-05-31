import sys

def decode_instruction(inst_hex):
    inst = int(inst_hex, 16)
    
    opcode = inst & 0x7F
    
    I_TYPE_OPS = {0b0010011, 0b0000011, 0b1100111}
    S_TYPE_OPS = {0b0100011}
    B_TYPE_OPS = {0b1100011}
    U_TYPE_OPS = {0b0110111, 0b0010111}
    J_TYPE_OPS = {0b1101111}
    
    imm = 0
    
    if opcode in I_TYPE_OPS:
        imm_raw = (inst >> 20) & 0xFFF  # Faltava esta linha
        imm = imm_raw if (imm_raw >> 11) == 0 else imm_raw - 4096
        
    elif opcode in S_TYPE_OPS:
        imm_11_5 = (inst >> 25) & 0x7F
        imm_4_0 = (inst >> 7) & 0x1F
        imm_raw = (imm_11_5 << 5) | imm_4_0
        imm = imm_raw if (imm_raw >> 11) == 0 else imm_raw - 4096
        
    elif opcode in B_TYPE_OPS:
        bit12 = (inst >> 31) & 0x1
        bit11 = (inst >> 7) & 0x1
        bits_10_5 = (inst >> 25) & 0x3F
        bits_4_1 = (inst >> 8) & 0xF
        
        imm_raw = (bit12 << 12) | (bit11 << 11) | (bits_10_5 << 5) | (bits_4_1 << 1)
        imm = imm_raw if (imm_raw >> 12) == 0 else imm_raw - 8192
        
    elif opcode in U_TYPE_OPS:
        imm_raw = (inst >> 12) & 0xFFFFF
        imm = imm_raw << 12
        
    elif opcode in J_TYPE_OPS:
        bit20 = (inst >> 31) & 0x1
        bits_19_12 = (inst >> 12) & 0xFF
        bit11 = (inst >> 20) & 0x1
        bits_10_1 = (inst >> 21) & 0x3FF
        
        imm_raw = (bit20 << 20) | (bits_19_12 << 12) | (bit11 << 11) | (bits_10_1 << 1)
        imm = imm_raw if (imm_raw >> 20) == 0 else imm_raw - 2097152
        
    else:
        imm = None
        
    return imm

def main():
    input_file = "codigos.hex"
    output_file = "imediatos.hex"
    
    try:
        with open(input_file, 'r') as f:
            instructions = f.readlines()
    except FileNotFoundError:
        print(f"Erro: Arquivo '{input_file}' não encontrado.")
        print("Execute 'make' primeiro para gerar o arquivo.")
        sys.exit(1)
    
    with open(output_file, 'w') as f:
        for line in instructions:
            line = line.strip()
            if not line:
                continue
                
            imm = decode_instruction(line)
            
            if imm is not None:
                if imm < 0:
                    imm_hex = f"{imm & 0xFFFFFFFF:08x}"
                else:
                    imm_hex = f"{imm:08x}"
                f.write(f"{imm_hex}\n")
    
    print(f"Arquivo gerado: {output_file}")

if __name__ == "__main__":
    main()