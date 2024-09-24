module registers (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    output reg [31:0] register_source_1,
    output reg [31:0] register_source_2,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire redWrite
);

    reg [31:0] x [0:31];
    reg [31:0] trash;

initial begin
    x[0]  <= 32'b0;
    x[1]  <= 32'b0;
    x[2]  <= 32'b0;
    x[3]  <= 32'b0;
    x[4]  <= 32'b0;
    x[5]  <= 32'b0;
    x[6]  <= 32'b0;
    x[7]  <= 32'b0;
    x[8]  <= 32'b0;
    x[9]  <= 32'b0;
    x[10] <= 32'b0;
    x[11] <= 32'b0;
    x[12] <= 32'b0;
    x[13] <= 32'b0;
    x[14] <= 32'b0;
    x[15] <= 32'b0;
    x[16] <= 32'b0;
    x[17] <= 32'b0;
    x[18] <= 32'b0;
    x[19] <= 32'b0;
    x[20] <= 32'b0;
    x[21] <= 32'b0;
    x[22] <= 32'b0;
    x[23] <= 32'b0;
    x[24] <= 32'b0;
    x[25] <= 32'b0;
    x[26] <= 32'b0;
    x[27] <= 32'b0;
    x[28] <= 32'b0;
    x[29] <= 32'b0;
    x[30] <= 32'b0;
    x[31] <= 32'b0;
end

always @(posedge clk) begin
    if (rst) begin
        x[0]  <= 32'b0;
        x[1]  <= 32'b0;
        x[2]  <= 32'b0;
        x[3]  <= 32'b0;
        x[4]  <= 32'b0;
        x[5]  <= 32'b0;
        x[6]  <= 32'b0;
        x[7]  <= 32'b0;
        x[8]  <= 32'b0;
        x[9]  <= 32'b0;
        x[10] <= 32'b0;
        x[11] <= 32'b0;
        x[12] <= 32'b0;
        x[13] <= 32'b0;
        x[14] <= 32'b0;
        x[15] <= 32'b0;
        x[16] <= 32'b0;
        x[17] <= 32'b0;
        x[18] <= 32'b0;
        x[19] <= 32'b0;
        x[20] <= 32'b0;
        x[21] <= 32'b0;
        x[22] <= 32'b0;
        x[23] <= 32'b0;
        x[24] <= 32'b0;
        x[25] <= 32'b0;
        x[26] <= 32'b0;
        x[27] <= 32'b0;
        x[28] <= 32'b0;
        x[29] <= 32'b0;
        x[30] <= 32'b0;
        x[31] <= 32'b0;
    end else begin
        register_source_1 <= x[rs1];
        register_source_2 <= x[rs2];
        if (redWrite) begin
            if (rd != 5'b00000) begin
                x[rd] <= data_in;
            end else begin
                trash <= data_in;
            end
        end
    end
end

endmodule
