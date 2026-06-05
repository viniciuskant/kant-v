module top #(
    parameter WIDTH = 32,
    parameter WORD_BYTES = 4,
    parameter DEPTH_WORDS = 256,
    parameter WIDTH_ADDRESS = 32
)(
    input logic clk,
    input logic rst
);
    logic [WIDTH-1:0] pc;
    logic readInstruction;
    logic [WIDTH-1:0] instruction;

    logic memoryWrite;
    logic memoryRead;
    logic [WIDTH-1:0] memoryWriteData;
    logic [WIDTH-1:0] memoryReadData;
    logic [WIDTH_ADDRESS-1:0] memoryAddress;

    logic cpu_rdy;

    memory #(
        .WORD_BYTES(WORD_BYTES),
        .ADDR_WIDTH(WIDTH_ADDRESS),
        .DEPTH_WORDS(DEPTH_WORDS),
        .INIT_FILE("../tb/data/codigo_top.hex")
    ) instruction_memory (
        .clk(clk),
        .memoryWrite(1'b0),
        .memoryRead(readInstruction),
        .memoryWriteData('0),
        .memoryAddress(pc),
        .memoryOutData(instruction)
    );

    memory #(
        .WORD_BYTES(WORD_BYTES),
        .ADDR_WIDTH(WIDTH_ADDRESS),
        .DEPTH_WORDS(DEPTH_WORDS)
    ) data_memory (
        .clk(clk),
        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .memoryWriteData(memoryWriteData),
        .memoryAddress(memoryAddress),
        .memoryOutData(memoryReadData)
    );

    cpu #(
        .WIDTH(WIDTH),
        .WIDTH_ADDRESS(WIDTH_ADDRESS)
    ) cpu_inst (
        .clk(clk),
        .rst(rst),

        .pc(pc),
        .readInstruction(readInstruction),
        .instruction(instruction),

        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .memoryWriteData(memoryWriteData),
        .memoryReadData(memoryReadData),
        .memoryAddress(memoryAddress),

        .cpu_rdy(cpu_rdy)
    );

endmodule