module control (
    input logic clk,
    input logic rst,
    input logic [6:0] opcode, 
    input logic [2:0] func3,
    input logic [6:0] func7,

    output logic instruction_en,
    output logic register_en,
    output logic aluout_en,
    output logic out_en,
    
    output logic regWrite,
    output logic [3:0] aluOperation,
    output logic mux_alu_rs1,
    output logic [1:0] mux_alu_rs2,
    output logic [1:0] mux_register_bank,

    output logic memoryWrite,
    output logic memoryRead,

    output logic [1:0] mux_pc,
    output logic cpu_rdy

);
localparam FLOW_NORMAL = 2'b00;
localparam FLOW_JAL = 2'b01;
localparam FLOW_JALR = 2'b10;
localparam FLOW_CONDITIONAL = 2'b11;

localparam USE_RS1 = 1'b0;
localparam USE_PC = 1'b1;

localparam USE_RS2 = 2'b00;
localparam USE_IMM = 2'b01;
localparam USE_FOUR = 2'b10;

localparam USE_RESULT = 2'b00;
// localparam USE_IMM = 2'b01;
localparam USE_JUMP = 2'b10;
localparam USE_MEMORY = 2'b11;

typedef enum logic [2:0] {
    RESET = 3'b000,
    FETCH = 3'b001,
    DECODER = 3'b010,
    EXECUTE = 3'b011,
    MEMORY = 3'b100
} state_t;
state_t current_state, next_state;

// lógica de transição
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        current_state <= RESET;
    else
        current_state <= next_state;
end

// lógica de próximo estado
always_comb begin
    next_state = current_state;

    unique case (current_state)
        RESET: next_state = FETCH;
        FETCH: next_state = DECODER;
        DECODER: next_state = EXECUTE;
        EXECUTE: next_state = MEMORY;
        MEMORY: next_state = FETCH;
        default: next_state = RESET;
    endcase
end


// Main control logic
always_comb begin
    instruction_en = 1'b0;
    register_en = 1'b0;
    aluout_en = 1'b0;
    out_en = 1'b0;
    regWrite = 1'b0;
    memoryRead = 1'b0;
    memoryWrite = 1'b0;
    aluOperation =  4'b0000;
    mux_alu_rs1 = USE_RS1;
    mux_alu_rs2 = USE_RS2;
    mux_register_bank = USE_RESULT;
    mux_pc = FLOW_NORMAL;
    cpu_rdy = 1'b0;
    memoryWrite = 1'b0;
    case (current_state) 
        RESET: begin
            cpu_rdy = 0;
        end

        FETCH: begin
            instruction_en = 1'b1;
        end

        DECODER: begin
            register_en = 1'b1;
        end

        EXECUTE: begin
            aluout_en = 1'b1;
            case(opcode)
                7'b0110011: begin // R-Type
                    mux_alu_rs1 = USE_RS1;
                    mux_alu_rs2 = USE_RS2;
                    case (func3)
                        3'b000: aluOperation = (func7 == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB or ADD
                        3'b001: aluOperation = 4'b0010; // SLL
                        3'b010: aluOperation = 4'b0011; // SLT
                        3'b011: aluOperation = 4'b0100; // SLTU
                        3'b101: aluOperation = (func7 == 7'b0100000) ? 4'b0101 : 4'b0110; // SRA or SRL
                        3'b100: aluOperation = 4'b0111; // XOR
                        3'b110: aluOperation = 4'b1000; // OR
                        3'b111: aluOperation = 4'b1001; // AND
                        default: aluOperation = 4'b0000; // Default case
                    endcase
                end 
                
                7'b0010011: begin // I-Type
                    mux_alu_rs1 = USE_RS1;
                    mux_alu_rs2 = USE_IMM;
                    case (func3)
                        3'b000: aluOperation = 4'b0000; // ADDI
                        3'b001: aluOperation = 4'b0010; // SLLI
                        3'b010: aluOperation = 4'b0011; // SLTI
                        3'b011: aluOperation = 4'b0100; // SLTIU
                        3'b100: aluOperation = 4'b0111; // XORI
                        3'b101: aluOperation = (func7 == 7'b0100000) ? 4'b0101 : 4'b0110; // SRAI or SRLI
                        3'b110: aluOperation = 4'b1000; // ORI
                        3'b111: aluOperation = 4'b1001; // ANDI
                        default: aluOperation = 4'b0000; // Default case
                    endcase
                end

                7'b0000011: begin // Load (I-Type)
                    aluOperation = 4'b0000;
                    aluOperation = 4'b0000; // ADD rs1 + imm
                    memoryRead = 1'b1;
                    mux_alu_rs1 = USE_RS1;
                    mux_alu_rs2 = USE_IMM;
                end

                7'b0100011: begin // Store (S-Type)
                    memoryRead = 1'b0;
                    aluOperation = 4'b0000;
                    aluOperation = 4'b0000; // ADD rs1 + imm
                    memoryRead = 1'b0;
                    mux_alu_rs1 = USE_RS1;
                    mux_alu_rs2 = USE_IMM;
                end

                7'b1100011: begin // Branch (B-Type)
                    memoryRead = 1'b0;
                    aluOperation = 4'b0001;
                    mux_alu_rs1 = USE_RS1;
                    mux_alu_rs2 = USE_RS2;
                end

                7'b1101111: begin // JAL (J-Type)
                    memoryRead = 1'b0;
                    aluOperation = 4'b0000;
                    mux_alu_rs1 = USE_PC;
                    mux_alu_rs2 = USE_FOUR;
                end

                7'b1100111: begin // JALR (I-Type)
                    memoryRead = 1'b0;
                    aluOperation = 4'b0000;
                    mux_alu_rs1 = USE_PC;
                    mux_alu_rs2 = USE_FOUR;
                end
                7'b0010111: begin // AUIPC (U-Type)
                    memoryRead = 1'b0;
                    mux_alu_rs1 = USE_PC;
                    mux_alu_rs2 = USE_IMM;
                    aluOperation = 4'b0000;
                    aluOperation = 4'b0000; // ADD pc + imm
                end
                7'b0110111: begin // LUI (U-Type)
                    memoryRead = 1'b0;
                    aluOperation = 4'b0000;
                    mux_alu_rs1 = USE_RS1;
                    mux_alu_rs2 = USE_RS2;
                end

                default: begin // Default case for unsupported instructions
                    memoryRead = 1'b0;
                    aluOperation = 4'b0000;
                    mux_alu_rs1 = USE_RS1;
                    mux_alu_rs2 = USE_RS2;
                end
            endcase
        end
        MEMORY: begin
            out_en = 1'b1;
            cpu_rdy = 1'b1;
            mux_register_bank = USE_RESULT;
            regWrite = 1'b1;
            memoryWrite = 1'b0;
            memoryRead = 1'b0;
            mux_pc = FLOW_NORMAL;
            case(opcode)
                7'b0110011: begin // R-Type
                    mux_register_bank = USE_RESULT;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b1;
                    mux_pc = FLOW_NORMAL;
                end 
                
                7'b0010011: begin // I-Type
                    mux_register_bank = USE_RESULT;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b1;
                    mux_pc = FLOW_NORMAL;
                end

                7'b0000011: begin // Load (I-Type)
                    mux_register_bank = USE_MEMORY;
                    memoryRead = 1'b1;
                    memoryWrite = 1'b0;
                    regWrite = 1'b1;
                    mux_pc = FLOW_NORMAL;
                end

                7'b0100011: begin // Store (S-Type)
                    mux_register_bank = USE_RESULT;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b1;
                    regWrite = 1'b0;
                    mux_pc = FLOW_NORMAL;
                end

                7'b1100011: begin // Branch (B-Type)
                    mux_register_bank = USE_RESULT;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b0; 
                    mux_pc = FLOW_CONDITIONAL;
                end

                7'b1101111: begin // JAL (J-Type)
                    mux_register_bank = USE_JUMP;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b1; 
                    mux_pc = FLOW_JAL;
                end

                7'b1100111: begin // JALR (I-Type)
                    mux_register_bank = USE_JUMP;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b1; 
                    mux_pc = FLOW_JALR;
                end

                7'b0010111: begin // AUIPC (U-Type)
                    mux_register_bank = USE_RESULT;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b1; 
                    mux_pc = FLOW_NORMAL;
                end

                 7'b0110111: begin // LUI (U-Type)
                    mux_register_bank = USE_IMM;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b1; 
                    mux_pc = FLOW_NORMAL;
                 end

                default: begin // Default case for unsupported instructions
                    mux_register_bank = USE_RESULT;
                    memoryRead = 1'b0;
                    memoryWrite = 1'b0;
                    regWrite = 1'b0;
                    mux_pc = FLOW_NORMAL;
                end
            endcase
        end
        default: begin
            instruction_en = 1'b0;
            register_en    = 1'b0;
            aluout_en      = 1'b0;
            out_en         = 1'b0;
            regWrite       = 1'b0;
            memoryRead        = 1'b0;
            memoryWrite       = 1'b0;
            memoryWrite = 1'b0;
            memoryRead = 1'b0;
            aluOperation   = 4'b0000;
            cpu_rdy        = 1'b0;
            mux_pc = FLOW_NORMAL;
            mux_alu_rs1 = USE_RS1;
            mux_alu_rs2 = USE_RS2;
            mux_register_bank = USE_RESULT;
        end
    endcase
end

endmodule
