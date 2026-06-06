module alu #(
    parameter WIDTH = 32
)(
    input logic signed [WIDTH-1:0] operand_1,
    input logic signed [WIDTH-1:0] operand_2,
    input logic [3:0] aluOperation,
    output logic signed [WIDTH-1:0] result,
    output logic zero,
    output logic less,
    output logic less_u
);
assign zero = (result == {WIDTH{1'b0}});
assign less   = ($signed(operand_1) < $signed(operand_2));
assign less_u = ($unsigned(operand_1) < $unsigned(operand_2));

localparam int MAX_SHIFT = $clog2(WIDTH);

always_comb begin
    case (aluOperation)
        4'b0000: result = operand_1 + operand_2; // ADD or ADDI 
        4'b0001: result = operand_1 - operand_2; // SUB 
        4'b0010: result = operand_1 << operand_2[MAX_SHIFT-1:0]; // SLL or SLLI 
        4'b0011: result = (operand_1 < operand_2) ? 32'b1 : 32'b0; // SLT or SLTI  
        4'b0100: result = ($unsigned(operand_1) < $unsigned(operand_2)) ? 32'b1 : 32'b0; // SLTU or SLTIU  
        4'b0101: result = operand_1 >>> operand_2[MAX_SHIFT-1:0]; // SRA 
        4'b0110: result = operand_1 >> operand_2[MAX_SHIFT-1:0]; // SRL 
        4'b0111: result = operand_1 ^ operand_2; // XOR or XORI 
        4'b1000: result = operand_1 | operand_2; // OR or ORI 
        4'b1001: result = operand_1 & operand_2; // AND or ANDI 
        default: result = operand_1;
    endcase
end

endmodule
