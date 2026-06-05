`timescale 1ns / 1ps

module register_bank_tb;

    parameter WIDTH  = 8;
    parameter PERIOD = 10;

    logic clk;
    logic rst;
    logic [WIDTH-1:0] in;
    logic [WIDTH-1:0] out;
    logic wr_en;

    register_bank #(.WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out),
        .wr_en(wr_en)
    );

    // clock
    always #(PERIOD/2) clk = ~clk;

    // write
    task write(input logic [WIDTH-1:0] data);
    begin
        @(posedge clk);
        wr_en = 1;
        in    = data;

        @(posedge clk);
        wr_en = 0;

        $display("[WRITE] data=%h", data);
    end
    endtask

    // read
    task read_check(input logic [WIDTH-1:0] expected);
    begin
        @(posedge clk);
        if (out !== expected) begin
            $display("READ ERROR | expected=%h got=%h", expected, out);
        end else begin
            $display("READ OK    | value=%h", out);
        end
    end
    endtask

    // reset
    task do_reset();
    begin
        rst = 1;
        wr_en = 0;
        in = 0;

        repeat (2) @(posedge clk);

        rst = 0;

        @(posedge clk);

        if (out !== 0)
            $display("RESET FAIL | out=%h", out);
        else
            $display("RESET OK");
    end
    endtask

    // testbench
    initial begin
        $dumpfile("register_bank_wave.vcd");
        $dumpvars(0, register_bank_tb);

        clk   = 0;
        rst   = 0;
        wr_en = 0;
        in    = 0;

        // reset inicial
        do_reset();

        // TESTE 1: escrever e ler
        write(8'hAA);
        read_check(8'hAA);

        // TESTE 2: escrever dois valores e ler o último
        write(8'h55);
        write(8'hCC);
        read_check(8'hCC);

        // TESTE 3: reset e verificar
        do_reset();

        // TESTE 4: escrever pós-reset e ler
        write(8'hF0);
        read_check(8'hF0);

        #20;
        $display("Fim dos testes");
        $finish;
    end

endmodule
