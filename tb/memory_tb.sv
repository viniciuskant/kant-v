module memory_tb;

    parameter WIDTH = 32;
    parameter WIDTH_ADDRESS = 8;
    parameter PERIOD = 10;

    logic clk;
    logic memoryWrite;
    logic memoryRead;
    logic [WIDTH-1:0] memoryWriteData;
    logic [WIDTH_ADDRESS-1:0] memoryAddress;
    logic [WIDTH-1:0] memoryOutData;

    int fail_count = 0;
    int test_num = 0;

    task automatic check(
        input logic [31:0] out,
        input logic [31:0] expected
    );
    begin
        if (out !== expected) begin
            $error("FAIL test %0d: got=0x%08h expected=0x%08h",
                   test_num + 1, out, expected);
            fail_count++;
        end
        test_num++;
    end
    endtask

    // clock
    always #(PERIOD/2) clk = ~clk;

    memory uut (
        .clk(clk),
        .memoryWrite(memoryWrite),
        .memoryRead(memoryRead),
        .memoryWriteData(memoryWriteData),
        .memoryAddress(memoryAddress),
        .memoryOutData(memoryOutData)
    );

    initial begin
        $dumpfile("memory_wave.vcd");
        $dumpvars(0, memory_tb);

        clk = 0;
        memoryWrite = 0;
        memoryRead = 0;
        memoryWriteData = 0;
        memoryAddress = 0;

        // Caso 1
        @(posedge clk);
        memoryWrite = 1;
        memoryAddress = 0;
        memoryWriteData = 32'h0000AAAA;
        @(posedge clk);
        memoryWrite = 0;

        memoryRead = 1;
        @(posedge clk);
        check(memoryOutData, 32'h0000AAAA);
        memoryRead = 0;

        // Caso 2
        @(posedge clk);
        memoryWrite = 1;
        memoryAddress = 8'hFF;
        memoryWriteData = 32'h00005555;
        @(posedge clk);
        memoryWrite = 0;

        memoryRead = 1;
        @(posedge clk);
        check(memoryOutData, 32'h00005555);
        memoryRead = 0;

        // Caso 3
        @(posedge clk);
        memoryWrite = 1;
        memoryAddress = 8'h10;
        memoryWriteData = 32'h00001111;
        @(posedge clk);
        memoryWriteData = 32'h00002222;
        @(posedge clk);
        memoryWrite = 0;

        memoryRead = 1;
        @(posedge clk);
        check(memoryOutData, 32'h00002222);  //TODO: entender o erro
        memoryRead = 0;

        // Caso 4
        @(posedge clk);
        memoryAddress = 8'h20;
        memoryRead = 1;
        @(posedge clk);

        check(memoryOutData, 32'hxxxxxxxx);

        memoryRead = 0;

        // Caso 5
        @(posedge clk);
        memoryAddress = 8'h30;
        memoryWriteData = 32'h0000DEAD;
        memoryWrite = 1;
        memoryRead = 1;
        @(posedge clk);

        check(memoryOutData, 32'h0000DEAD);

        memoryWrite = 0;
        memoryRead = 0;

        // Caso 6
        @(posedge clk);
        memoryWrite = 1;
        memoryAddress = 8'h40;
        memoryWriteData = 32'h0000AAAA;
        @(posedge clk);
        memoryAddress = 8'h41;
        memoryWriteData = 32'h0000BBBB;
        @(posedge clk);
        memoryWrite = 0;

        memoryRead = 1;

        memoryAddress = 8'h40;
        @(posedge clk);
        check(memoryOutData, 32'h0000AAAA);

        memoryAddress = 8'h41;
        @(posedge clk);
        check(memoryOutData, 32'h0000BBBB);  //TODO: entender o erro

        memoryRead = 0;

        // Caso 7
        @(posedge clk);
        memoryWrite = 1;
        memoryAddress = 8'h50;
        memoryWriteData = 32'h00000000;
        @(posedge clk);
        memoryWrite = 0;

        memoryRead = 1;
        @(posedge clk);
        check(memoryOutData, 32'h00000000);
        memoryRead = 0;

        // Caso 8
        @(posedge clk);
        memoryWrite = 1;
        memoryAddress = 8'h60;
        memoryWriteData = 32'h0000FFFF;
        @(posedge clk);
        memoryWrite = 0;

        memoryRead = 1;
        @(posedge clk);
        check(memoryOutData, 32'h0000FFFF);
        memoryRead = 0;

        if (fail_count == 0)
            $display("PASSED all tests");
        else
            $error("FAILED %0d test(s)", fail_count);

        $finish;
    end

endmodule