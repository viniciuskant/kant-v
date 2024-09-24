module alu (
    input wire clk,
    input wire rst,
    input wire [31:0] operand_1,
    input wire [31:0] operand_2,
    input wire [2:0] alu_op, //func3
    input wire [6:0] alu_op2, //func7
    output wire [31:0] result,
    output wire zero,
);

/*
    R-Type      | I-Type                     I-Type
    func3 | func7 | Descrição                func3 | Descrição  
    --------------------------               ------------------       
    000   | 0000000 | ADD                    010   | SLTI  
    000   | 0100000 | SUB                    011   | SLTIU  
    001   | 0000000 | SLL                    100   | XORI  
    010   | 0000000 | SLT                    110   | ORI  
    011   | 0000000 | SLTU                   111   | ANDI        
    100   | 0000000 | XOR                   
    101   | 0000000 | SRL                       
    101   | 0100000 | SRA                       
    110   | 0000000 | OR                         
    111   | 0000000 | AND                      
*/