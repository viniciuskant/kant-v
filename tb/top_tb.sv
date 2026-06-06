`timescale 1ns/1ps

module top_tb;

    parameter WIDTH = 32;
    parameter WORD_BYTES = 4;
    parameter DEPTH_WORDS = 512;
    parameter WIDTH_ADDRESS = 32;

    logic clk;
    logic rst;

    top #(
        .WIDTH(WIDTH),
        .WIDTH_ADDRESS(WIDTH_ADDRESS),
        .DEPTH_WORDS(DEPTH_WORDS),
        .WIDTH_ADDRESS(WIDTH_ADDRESS)
    ) u_top (
        .clk(clk),
        .rst(rst)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset
    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top_tb);
    end

    // Monitor
    initial begin
        $display("Tempo\tPC\t\tInstrucao");
        $monitor("%0t\t%08h\t%08h", $time, u_top.pc, u_top.instruction);
    end

    // Finalização
    initial begin
        #5000;
        $display("\nFim da simulacao");
        $finish;
    end

    // initial begin
    //     #1;
    //     $display("\n=== Conteudo da memoria de instrucoes ===");
    //     for (int i = 0; i < 9; i++) begin
    //         $display("mem[%0d] = %08h",
    //                 i,
    //                 u_top.instruction_memory.mem[i]);
    //     end
    // end


    initial begin
        #4995;

        $display("\n=== Conteudo final da memoria de dados ===");

        for (int i = 0; i < 128; i++) begin
            $display("mem[%0d] = %08h",
                    i,
                    u_top.data_memory.mem[i]);
        end
    end

endmodule