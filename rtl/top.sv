module top #(
    parameter WIDTH = 32,
    parameter WORD_BYTES = 4,
    parameter DEPTH_WORDS = 256,
    parameter WIDTH_ADDRESS = 32,
    parameter int BASE_ADDR     = 32'h8000_0000,
    parameter ADDR_PC_INIT = 32'h0000_0000
)(
    input logic clk,
    output logic [31:0] debug_gp,
    input logic rst
);

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
        .BASE_ADDR(BASE_ADDR)
    ) u_memory (
        .clk(clk),
        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .memoryWriteData(memoryWriteData),
        .memoryReadData(memoryReadData),
        .memoryAddress(memoryAddress)
    );

    cpu #(
        .WIDTH(WIDTH),
        .WIDTH_ADDRESS(WIDTH_ADDRESS),
        .ADDR_PC_INIT(ADDR_PC_INIT)
    ) u_cpu (
        .clk(clk),
        .rst(rst),

        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .memoryWriteData(memoryWriteData),
        .memoryReadData(memoryReadData),
        .memoryAddress(memoryAddress),
        .debug_gp(debug_gp),
        .cpu_rdy(cpu_rdy)
    );

endmodule