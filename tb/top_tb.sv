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

    // Dump VCD
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top_tb);
    end

    // Monitor simples
    initial begin
        $display("Tempo\tPC\t\tInstrucao");
        $monitor("%0t\t%08h\t%08h", $time, u_top.pc, u_top.instruction);
    end

    // =============================================
    // Autoverificação e controle da simulação
    // =============================================
initial begin
    // Aguarda o reset ser desativado
    wait(rst == 0);
    #1;

    fork
        // ERRO: x5 = -1
        begin
            wait(u_top.cpu_inst.u_register_bank.x[5] == 32'hFFFFFFFF);
            #50;
            $display("\n=== ERRO DETECTADO (x5 = -1) ===");
            $display("x5 = %08h", u_top.cpu_inst.u_register_bank.x[5]);
            $finish;
        end

        // SUCESSO: x5 = 5
        begin
            wait(u_top.cpu_inst.u_register_bank.x[5] == 32'd5);
            #50;
            $display("\n=== TESTE PASSOU (x5 = 5) ===");
            $display("x5 = %08h", u_top.cpu_inst.u_register_bank.x[5]);

            $display("=== Conteudo final da memoria de dados ===");
            for (int i = 0; i < 128; i++) begin
                $display("mem[%0d] = %08h", i, u_top.data_memory.mem[i]);
            end

            $finish;
        end

        // Timeout
        begin
            #9000;

            $display("\n=== TEMPO LIMITE ATINGIDO ===");
            $display("x5 = %08h", u_top.cpu_inst.u_register_bank.x[5]);

            if (u_top.cpu_inst.u_register_bank.x[5] == 32'd1) begin
                $display("*** TESTE NAO TERMINOU (tempo insuficiente) ***");
            end
            else if (u_top.cpu_inst.u_register_bank.x[5] == 32'd5) begin
                $display("*** TESTE PASSOU ***");
            end
            else if (u_top.cpu_inst.u_register_bank.x[5] == 32'hFFFFFFFF) begin
                $display("*** TESTE FALHOU (erro) ***");
            end
            else begin
                $display("*** ESTADO INESPERADO DE x5 ***");
            end

            $finish;
        end
    join_any

    disable fork;
end
endmodule