`timescale 1ns/1ps

module top_tb;

    localparam WIDTH = 32;
    localparam WORD_BYTES = 4;
    localparam DEPTH_WORDS = 4096;
    localparam WIDTH_ADDRESS = 32;
    localparam BASE_MEM_ADDR = 32'h2000_0000; 
    localparam TOHOST_ADDR   = 32'h2000_1000;
    localparam PASS_VALUE  = 1; 
    localparam FAIL_VALUE  = 0; 


    logic clk;
    logic rst;

    top #(
        .WIDTH(WIDTH),
        .WIDTH_ADDRESS(WIDTH_ADDRESS),
        .DEPTH_WORDS(DEPTH_WORDS),
        .BASE_ADDR(BASE_MEM_ADDR),
        .ADDR_PC_INIT(BASE_MEM_ADDR)
    ) u_top (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top_tb);
    end

    // initial begin
    //     $display("Tempo\tPC\t\tInstrucao");
    //     $monitor("%0t\t%08h\t%08h", $time, u_top.u_cpu.reg_PC, u_top.u_cpu.reg_instruction);
    // end

    initial begin
        wait(rst == 0);
        #1;
        $display("Iniciando simulação do teste");

        fork
            forever begin
                @(posedge clk);
                if (u_top.u_cpu.reg_instruction == 32'h00000073) begin // detectar ecall
                    if (u_top.u_cpu.reg_instruction == 32'h00000073) begin
                        if (u_top.debug_gp == 1)
                            $display("TESTE PASSOU (ecall)");
                        else
                            $display("TESTE FALHOU (ecall), gp=%0d", u_top.debug_gp);
                        $finish;
                    end
                end
            end
            begin
                repeat (200000) @(posedge clk);
                $display("\n=== TIMEOUT - Teste não terminou ===");
                $finish;
            end
        join_any
        disable fork;
    end

endmodule