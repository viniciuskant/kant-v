import sys

def sign_extend(value, bits):
    sign_bit = 1 << (bits - 1)
    return (value ^ sign_bit) - sign_bit

def decode_instruction(inst_hex):
    inst = int(inst_hex, 16)

    opcode = inst & 0x7F

    I_TYPE_OPS = {
        0b0010011,  # OP-IMM
        0b0000011,  # LOAD
        0b1100111,  # JALR
        0b1110011   # SYSTEM
    }

    S_TYPE_OPS = {
        0b0100011
    }

    B_TYPE_OPS = {
        0b1100011
    }

    U_TYPE_OPS = {
        0b0110111,  # LUI
        0b0010111   # AUIPC
    }

    J_TYPE_OPS = {
        0b1101111   # JAL
    }

    if opcode in I_TYPE_OPS:

        imm_raw = (inst >> 20) & 0xFFF
        return sign_extend(imm_raw, 12)

    elif opcode in S_TYPE_OPS:

        imm_raw = (
            ((inst >> 25) & 0x7F) << 5
        ) | (
            ((inst >> 7) & 0x1F)
        )

        return sign_extend(imm_raw, 12)

    elif opcode in B_TYPE_OPS:

        imm_raw = (
            ((inst >> 31) & 1) << 12 |
            ((inst >> 7) & 1) << 11 |
            ((inst >> 25) & 0x3F) << 5 |
            ((inst >> 8) & 0xF) << 1
        )

        return sign_extend(imm_raw, 13)

    elif opcode in U_TYPE_OPS:

        return inst & 0xFFFFF000

    elif opcode in J_TYPE_OPS:

        imm_raw = (
            ((inst >> 31) & 1) << 20 |
            ((inst >> 12) & 0xFF) << 12 |
            ((inst >> 20) & 1) << 11 |
            ((inst >> 21) & 0x3FF) << 1
        )

        return sign_extend(imm_raw, 21)

    return None

def main():

    input_file = "codigos.hex"
    output_file = "imediatos.hex"

    try:
        with open(input_file) as f:
            instructions = f.readlines()

    except FileNotFoundError:

        print(f"Erro: {input_file} não encontrado")
        sys.exit(1)

    with open(output_file, "w") as f:

        for line in instructions:

            line = line.strip()

            if not line:
                continue

            imm = decode_instruction(line)

            if imm is None:
                imm = 0

            f.write(f"{imm & 0xFFFFFFFF:08x}\n")

    print(f"Gerado: {output_file}")

if __name__ == "__main__":
    main()
