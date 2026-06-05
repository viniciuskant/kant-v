module gen_imm_tb;

    parameter WIDTH = 32;
    
    logic [WIDTH-1:0] instruction;
    logic signed [WIDTH-1:0] out;
    
    gen_imm #(.WIDTH(WIDTH)) dut (
        .instruction(instruction),
        .out(out)
    );
    
    function automatic logic signed [31:0] hex2int(input string s);
        logic signed [31:0] result;
        integer i, char_val;
        result = 0;
        for (i = 0; i < s.len(); i++) begin
            char_val = s[i];
            if (char_val == " " || char_val == "\n") break;
            result = result << 4;
            if (char_val >= "0" && char_val <= "9")
                result = result | (char_val - "0");
            else if (char_val >= "a" && char_val <= "f")
                result = result | (10 + char_val - "a");
        end
        return result;
    endfunction
    
    initial begin
        int codigos_fd, imediatos_fd;
        string line_codigo, line_imediato;
        logic signed [31:0] expected;
        int test_num = 0;
        int fail_count = 0;
        
        codigos_fd = $fopen("../tb/data/codigo_gen_imm.hex", "r");
        imediatos_fd = $fopen("../tb/data/imediatos.hex", "r");
        
        while (!$feof(codigos_fd) && !$feof(imediatos_fd)) begin
            if (!$fgets(line_codigo, codigos_fd)) break;
            if (!$fgets(line_imediato, imediatos_fd)) break;
            
            instruction = hex2int(line_codigo);
            expected = hex2int(line_imediato);
            
            #1;
            
            if (out !== expected) begin
                $error("FAIL test %0d: got=0x%08h expected=0x%08h", test_num+1, out, expected);
                fail_count++;
            end
            test_num++;
        end
        
        $fclose(codigos_fd);
        $fclose(imediatos_fd);
        
        if (fail_count == 0)
            $display("PASSED all test");
        else
            $error("FAILED %0d test(s)", fail_count);
        
        $finish;
    end

endmodule