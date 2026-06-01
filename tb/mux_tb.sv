module mux_tb;
    localparam int WIDTH = 8;
    localparam int N = 4;

    logic [WIDTH*N-1:0] in;
    logic [$clog2(N)-1:0] sel;
    logic [WIDTH-1:0] out;

    mux #(
        .WIDTH(WIDTH),
        .N(N)
    ) dut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    task automatic check(
        input logic [WIDTH*N-1:0] in_i,
        input logic [$clog2(N)-1:0] sel_i,
        input logic [WIDTH-1:0] exp
    );
    begin
        in  = in_i;
        sel = sel_i;
        #1;

        assert(out === exp)
        else
            $error("FAIL sel=%0d exp=0x%0h got=0x%0h",
                   sel_i, exp, out);
    end
    endtask

    initial begin
        check(32'h44332211, 0, 8'h11);
        check(32'h44332211, 1, 8'h22);
        check(32'h44332211, 2, 8'h33);
        check(32'h44332211, 3, 8'h44);

        check(32'hA5F03C7E, 0, 8'h7E);
        check(32'hA5F03C7E, 1, 8'h3C);
        check(32'hA5F03C7E, 2, 8'hF0);
        check(32'hA5F03C7E, 3, 8'hA5);

        $display("PASSED all test");
        $finish;
    end

endmodule