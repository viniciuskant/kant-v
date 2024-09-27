module alu (
    input wire [31:0] operand_1,
    input wire [31:0] operand_2,
    input wire [3:0] aluOperation,
    output reg [31:0] result,
    output wire zero
);

assign zero = (result == 32'b0);

always @(*) begin
    case (aluOperation)
        4'b0000: result <= operand_1 + operand_2; // ADD or ADDI 
        4'b0001: result <= operand_1 - operand_2; // SUB 
        4'b0010: result <= operand_1 << operand_2; // SLL or SLLI 
        4'b0011: result <= (operand_1 < operand_2) ? 32'b1 : 32'b0; // SLT or SLTI  
        4'b0100: result <= (operand_1 < operand_2) ? 32'b1 : 32'b0; // SLTU or SLTIU  
        4'b0101: result <= operand_1 >>> operand_2; // SRA 
        4'b0110: result <= operand_1 >> operand_2; // SRL 
        4'b0111: result <= operand_1 ^ operand_2; // XOR or XORI 
        4'b1000: result <= operand_1 | operand_2; // OR or ORI 
        4'b1001: result <= operand_1 & operand_2; // AND or ANDI 
        default: result <= operand_1;
    endcase
end

endmodule