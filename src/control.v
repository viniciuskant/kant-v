module control (
    input wire clk,
    input wire rst,
    input wire [6:0] opcode, 
    input wire [2:0] func3,
    input wire [6:0] func7,
    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg [3:0] aluOperation,
    output reg isImmediate,
    output reg [2:0] branch
);

/*
    R-Type                                 |I-Type
    opcode   |  func3 | func7 | Descrição  | opcode |   func3 | Descrição  
    ---------|---------------------------- |--------|----------------------       
    0110011  |  000   | 0000000 | ADD      |0010011 |   000   | ADDI     
    0110011  |  000   | 0100000 | SUB      |        |     
    0110011  |  001   | 0000000 | SLL      |        |   
    0110011  |  010   | 0000000 | SLT      |0010011 |   010   | SLTI  
    0110011  |  011   | 0000000 | SLTU     |0010011 |   011   | SLTIU        
    0110011  |  100   | 0000000 | XOR      |0010011 |   100   | XORI               
    0110011  |  101   | 0000000 | SRL      |        |                    
    0110011  |  101   | 0100000 | SRA      |        |                    
    0110011  |  110   | 0000000 | OR       |0010011 |   110   | ORI                  
    0110011  |  111   | 0000000 | AND      |0010011 |   111   | ANDI             
*/

/*
    aluOperation:
    0000: ADD or ADDI
    0001: SUB

    0010: SLL or SLLI
    0011: SLT or SLTI
    0100: SLTU or SLTIU
    0101: SRA 
    0110: SRL 

    0111: XOR or XORI
    1000: OR or ORI
    1001: AND or ANDI 
*/


// branch: select branch control signal based on opcode and func3
always @(*) begin
    if (opcode == 7'b1100011) // B-Type for branch instructions
        branch = func3;
    else
        branch = 3'b000;  // No branch
end

// Main control logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset control signals
        regWrite <= 1'b0;
        memRead <= 1'b0;
        memWrite <= 1'b0;
        aluOperation <= 4'b0000;
        branch <= 3'b0;
        isImmediate <= 1'b0;
    end else begin
        case (opcode) 
            7'b0110011: begin // R-Type
                regWrite <= 1'b1;
                memRead <= 1'b0;
                memWrite <= 1'b0;
                isImmediate <= 1'b0;
                case (func3)
                    3'b000: aluOperation <= (func7 == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB or ADD
                    3'b001: aluOperation <= 4'b0010; // SLL
                    3'b010: aluOperation <= 4'b0011; // SLT
                    3'b011: aluOperation <= 4'b0100; // SLTU
                    3'b101: aluOperation <= (func7 == 7'b0100000) ? 4'b0101 : 4'b0110; // SRA or SRL
                    3'b100: aluOperation <= 4'b0111; // XOR
                    3'b110: aluOperation <= 4'b1000; // OR
                    3'b111: aluOperation <= 4'b1001; // AND
                    default: aluOperation <= 4'b0000; // Default case
                endcase
            end 
            
            7'b0010011: begin // I-Type
                regWrite <= 1'b1;
                memRead <= 1'b0;
                memWrite <= 1'b0;
                isImmediate <= 1'b1;
                case (func3)
                    3'b000: aluOperation <= 4'b0000; // ADDI
                    3'b010: aluOperation <= 4'b0011; // SLTI
                    3'b011: aluOperation <= 4'b0100; // SLTIU
                    3'b100: aluOperation <= 4'b0001; // XORI
                    3'b110: aluOperation <= 4'b1000; // ORI
                    3'b111: aluOperation <= 4'b1001; // ANDI
                    default: aluOperation <= 4'b0000; // Default case
                endcase
            end

            7'b0100011: begin // Store (S-Type)
                regWrite <= 1'b0; 
                memRead <= 1'b0;
                memWrite <= 1'b0;
                aluOperation <= 4'b0000;
                isImmediate <= 1'b0;
            end

            7'b0100011: begin // Store (B-Type)
                regWrite <= 1'b0; 
                memRead <= 1'b0;
                memWrite <= 1'b0;
                aluOperation <= 4'b0000;
                isImmediate <= 1'b0;
            end

            7'b1101111: begin // JAL (J-Type)
                regWrite <= 1'b0; 
                memRead <= 1'b0;
                memWrite <= 1'b0;
                aluOperation <= 4'b0000;
                isImmediate <= 1'b0;
            end

            7'b0110111: begin // LUI (U-Type)
                regWrite <= 1'b0; 
                memRead <= 1'b0;
                memWrite <= 1'b0;
                aluOperation <= 4'b0000;
                isImmediate <= 1'b0;
            end

            default: begin // Default case for unsupported instructions
                regWrite <= 1'b0;
                memRead <= 1'b0;
                memWrite <= 1'b0;
                aluOperation <= 4'b0000;
                isImmediate <= 1'b0;
            end
        endcase
    end
end

endmodule
