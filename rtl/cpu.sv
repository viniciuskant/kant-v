module cpu #(
    parameter WIDTH = 32,
    parameter WIDTH_ADDRESS = 8
)(
    input clk,
    input rst,

    output logic [WIDTH-1:0] pc, 
    output logic readInstruction, //TODO
    input [WIDTH-1:0] instruction,
    
    output logic memoryWrite,
    output logic memoryRead,
    output logic [WIDTH-1:0] memoryWriteData,
    input  [WIDTH-1:0] memoryReadData,
    output logic [WIDTH_ADDRESS-1:0] memoryAddress,

    output logic cpu_rdy
);

    localparam ADDR_PC_INITIAL = 32'b0;
    logic signed [WIDTH-1:0] imm;
    logic regWrite;

    // FETCH
    logic [WIDTH-1:0] reg_instruction;
    logic instruction_en;
    register #(.WIDTH(WIDTH)) u_reg_instruction (
        .clk(clk),
        .rst(rst),
        .in(instruction),
        .out(reg_instruction),
        .wr_en(instruction_en)
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

    logic [6:0] opcode; 
    logic [2:0] func3;
    logic [6:0] func7;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    assign opcode = reg_instruction[6:0];
    assign func3 = reg_instruction[14:12];
    assign func7 = reg_instruction[31:25];
    assign rs1 = reg_instruction[19:15];
    assign rs2 = reg_instruction[24:20];
    assign rd = reg_instruction[11:07];

    assign readInstruction = instruction_en; //TODO temporarario

    logic unsigned [WIDTH-1:0] RA;
    logic [WIDTH-1:0] reg_result_alu;
    logic [WIDTH-1:0] regData;
    logic [1:0] mux_pc;
    logic [WIDTH-1:0] reg_data_out_rs2;


    // Para teste o enderecamento ta reduzido
    assign memoryAddress = reg_result_alu[WIDTH_ADDRESS-1:0];
    always_comb begin
        if (memoryWrite) 
            memoryWriteData = reg_data_out_rs2;
        else
            memoryWriteData = '0;
    end


    // DECODER
    logic [1:0] mux_register_bank;
    always_comb begin
        case (mux_register_bank)
            USE_RESULT: regData = reg_result_alu;
            USE_IMM: regData = imm;
            USE_JUMP: regData = RA;
            USE_MEMORY: begin
                case (func3)
                    3'b000: regData = {{24{memoryReadData[7]}},  memoryReadData[7:0]}; // LB
                    3'b001: regData = {{16{memoryReadData[15]}}, memoryReadData[15:0]}; // LH
                    3'b010: regData = memoryReadData;  // LW
                    3'b100: regData = {24'b0, memoryReadData[7:0]};  // LBU
                    3'b101: regData = {16'b0, memoryReadData[15:0]};  // LHU
                    default: regData = '0;
                endcase
            end
            default: regData = '0;
        endcase
    end

    logic [WIDTH-1:0] data_out_rs1, data_out_rs2;
    register_bank #(.WIDTH(WIDTH)) u_register_bank(
        .clk(clk),
        .data_in(regData),
        .data_out_rs1(data_out_rs1),
        .data_out_rs2(data_out_rs2),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .regWrite(regWrite) 
    );

    logic [WIDTH-1:0] reg_data_out_rs1;
    logic register_en;
    register #(.WIDTH(WIDTH)) u_reg_data_out_rs1 (
        .clk(clk),
        .rst(rst),
        .in(data_out_rs1),
        .out(reg_data_out_rs1),
        .wr_en(register_en)
    );

    register #(.WIDTH(WIDTH)) u_reg_data_out_rs2 (
        .clk(clk),
        .rst(rst),
        .in(data_out_rs2),
        .out(reg_data_out_rs2),
        .wr_en(register_en)
    );

    logic mux_alu_rs1;
    logic signed [WIDTH-1:0] op_1;
    logic unsigned [WIDTH-1:0] PC, PC_PLUS4, reg_PC;
    always_comb begin
        case (mux_alu_rs1)
            USE_RS1: op_1 = reg_data_out_rs1;
            USE_PC: op_1 = reg_PC;
        endcase
    end

    logic [1:0] mux_alu_rs2;
    logic signed [WIDTH-1:0] op_2;
    always_comb begin
        case (mux_alu_rs2)
            USE_IMM: op_2 = imm;
            USE_RS2: op_2 = reg_data_out_rs2;
            USE_FOUR: op_2 = WIDTH'(4);
            default: op_2 = '0;
        endcase
    end

    // EXECUTE
    logic [WIDTH-1:0] result_alu;
    logic zero, less, less_u;
    logic reg_zero, reg_less, reg_less_u;
    logic [3:0] aluOperation;
    alu #(.WIDTH(WIDTH)) u_alu(
        .operand_1(op_1),
        .operand_2(op_2),
        .aluOperation (aluOperation),
        .result (result_alu),
        .zero (zero),
        .less(less),
        .less_u(less_u)
    );

    logic takeBranch, isBranch;
    assign isBranch = (mux_pc == FLOW_CONDITIONAL);
    branch_unit u_branch_unit (
        .func3(func3),
        .isBranch(isBranch),
        .zero(reg_zero),
        .less(reg_less),
        .less_u(reg_less_u),
        .takeBranch(takeBranch)
    );

    logic aluout_en;
    register #(.WIDTH(WIDTH)) u_reg_result_alu (
        .clk(clk),
        .rst(rst),
        .in(result_alu),
        .out(reg_result_alu),
        .wr_en(aluout_en)
    );

    register #(.WIDTH(3)) u_reg_flag_alu (
        .clk(clk),
        .rst(rst),
        .in({zero, less, less_u}),
        .out({reg_zero, reg_less, reg_less_u}),
        .wr_en(aluout_en)
    );

    assign PC_PLUS4 = reg_PC + 32'h00000004;

    always_comb begin
        PC = PC_PLUS4;
        RA = '0;

        if (rst) begin
            PC = ADDR_PC_INITIAL;
        end else begin
            case (mux_pc)
                FLOW_NORMAL: begin
                    PC = PC_PLUS4;
                end

                FLOW_JAL: begin
                    PC = reg_PC + imm;
                    RA = PC_PLUS4;
                end

                FLOW_JALR: begin
                    PC = (reg_data_out_rs1 + imm) & ~1;
                    RA = PC_PLUS4;
                end

                FLOW_CONDITIONAL: begin
                    if (takeBranch)
                        PC = reg_PC + imm;
                    else
                        PC = PC_PLUS4;
                end

                default: begin
                    PC = PC_PLUS4;
                end
            endcase
        end
    end

    logic out_en;
    register #(.WIDTH(WIDTH)) u_reg_PC (
        .clk(clk),
        .rst(rst),
        .in(PC),
        .out(reg_PC),
        .wr_en(out_en) 
    );

    assign pc = reg_PC;


    control u_control (
        .clk(clk), //ok
        .rst(rst), //ok
        .opcode(opcode), //ok
        .func3(func3), //ok
        .func7(func7), //ok

        .instruction_en(instruction_en), //ok
        .register_en(register_en), //ok
        .aluout_en(aluout_en), //ok
        .out_en(out_en),
    
        .regWrite(regWrite), 
        .aluOperation(aluOperation), //ok

        .mux_alu_rs1(mux_alu_rs1),
        .mux_alu_rs2(mux_alu_rs2),
        .mux_register_bank(mux_register_bank),

        .memoryRead(memoryRead),
        .memoryWrite(memoryWrite),

        .mux_pc(mux_pc),
        .cpu_rdy(cpu_rdy)

    );

    gen_imm #(.WIDTH(WIDTH)) u_gen_imm (
        .instruction(reg_instruction),
        .out(imm)
    );


endmodule
