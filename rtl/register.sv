module register #(
	parameter WIDTH = 32,
    parameter PRE_SET = 32'h0000_0000
)(
	input clk,
	input rst,
	input [WIDTH-1:0] in,
	output logic [WIDTH-1:0] out,
	input wr_en
);

	logic [WIDTH-1:0] regs;
	assign out = regs;

	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			regs <= PRE_SET;
		end else begin 
			if (wr_en) regs <= in;
		end
	end


endmodule


