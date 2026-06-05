module branch_unit (
    input logic [2:0] func3,
    input logic isBranch,
    input logic zero, // rs1 == rs2
    input logic less, // rs1 < rs2 (signed)
    input logic less_u, // rs1 < rs2 (unsigned)
    output logic takeBranch
);

always @(*) begin
    takeBranch = 1'b0;

    if (isBranch) begin
        case (func3)
            3'b000: takeBranch =  zero; // BEQ
            3'b001: takeBranch = ~zero; // BNE
            3'b100: takeBranch =  less; // BLT
            3'b101: takeBranch = ~less; // BGE
            3'b110: takeBranch =  less_u; // BLTU
            3'b111: takeBranch = ~less_u; // BGEU
            default: takeBranch = 1'b0;
        endcase
    end
end

endmodule
