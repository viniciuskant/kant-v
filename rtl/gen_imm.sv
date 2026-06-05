module gen_imm #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] instruction,
    output logic signed [WIDTH-1:0] out
);

    logic [6:0] opcode;
    assign opcode = instruction[6:0];

    logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

    // I-Type
    assign imm_i = {{20{instruction[31]}}, instruction[31:20]};

    // S-Type
    assign imm_s = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

    // B-Type
    assign imm_b = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    // U-Type
    assign imm_u = {instruction[31:12], 12'b0};

    // J-Type
    assign imm_j = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

    always_comb begin
        case (opcode)
            7'b0010011, 7'b0000011, 7'b1100111: out = imm_i;
            7'b0100011: out = imm_s;
            7'b1100011: out = imm_b;
            7'b0110111, 7'b0010111: out = imm_u;
            7'b1101111: out = imm_j;
            default: out = '0;
        endcase
    end

endmodule
