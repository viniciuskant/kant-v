module register_bank #(
    parameter WIDTH = 32
)(
    input logic clk,
    input logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out_rs1,
    output logic [WIDTH-1:0] data_out_rs2,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic regWrite
);

logic [WIDTH-1:0] x [0:31];
assign data_out_rs1 = (rs1 == 0) ? '0 : x[rs1];
assign data_out_rs2 = (rs2 == 0) ? '0 : x[rs2];

always_ff @(posedge clk) begin
    if (regWrite && rd != 0) begin
        x[rd] <= data_in;
    end
end

endmodule
