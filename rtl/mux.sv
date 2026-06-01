module mux #(
    parameter int WIDTH = 8,
    parameter int N = 4
)(
    input logic [WIDTH*N-1:0] in,
    input logic [$clog2(N)-1:0] sel,
    output logic [WIDTH-1:0] out
);

    always_comb begin
        out = in[sel*WIDTH +: WIDTH];
    end

endmodule