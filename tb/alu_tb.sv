module alu_tb;

    typedef enum logic [3:0] {
        ALU_ADD  = 4'b0000,
        ALU_SUB  = 4'b0001,
        ALU_SLL  = 4'b0010,
        ALU_SLT  = 4'b0011,
        ALU_SLTU = 4'b0100,
        ALU_SRA  = 4'b0101,
        ALU_SRL  = 4'b0110,
        ALU_XOR  = 4'b0111,
        ALU_OR   = 4'b1000,
        ALU_AND  = 4'b1001
    } alu_op_t;

    logic signed [31:0] operand_1;
    logic signed [31:0] operand_2;
    alu_op_t            aluOperation;
    logic signed [31:0] result;
    logic               zero;

    alu dut (
        .operand_1(operand_1),
        .operand_2(operand_2),
        .aluOperation(aluOperation),
        .result(result),
        .zero(zero)
    );

    task automatic check(
        input alu_op_t op,
        input logic signed [31:0] a,
        input logic signed [31:0] b,
        input logic signed [31:0] exp
    );
    begin
        aluOperation = op;
        operand_1    = a;
        operand_2    = b;

        #1;

        assert(result === exp)
        else
            $error("FAIL op=%s a=%0d b=%0d exp=%0d got=%0d",
                   op.name(), a, b, exp, result);

        assert(zero === (exp == 0))
        else
            $error("FAIL ZERO op=%s", op.name());
    end
    endtask

    initial begin

        check(ALU_ADD , 10, 20, 30);
        check(ALU_ADD , -10, 20, 10);
        check(ALU_ADD , 32'sh7fffffff, 1, 32'sh80000000);
        check(ALU_ADD , 0, 0, 0);

        check(ALU_SUB , 20, 10, 10);
        check(ALU_SUB , -10, 20, -30);
        check(ALU_SUB , 0, 0, 0);
        check(ALU_SUB , 32'sh80000000, 1, 32'sh7fffffff);

        check(ALU_SLL , 1, 0, 1);
        check(ALU_SLL , 1, 1, 2);
        check(ALU_SLL , 1, 31, 32'sh80000000);
        check(ALU_SLL , 1, 32, 0);

        check(ALU_SLT , 5, 10, 1);
        check(ALU_SLT , 10, 5, 0);
        check(ALU_SLT , -1, 1, 1);
        check(ALU_SLT , 5, 5, 0);

        check(ALU_SLTU, 5, 10, 1);
        check(ALU_SLTU, 10, 5, 0);
        check(ALU_SLTU, -1, 1, 1);
        check(ALU_SLTU, 5, 5, 0);

        check(ALU_SRA , -16, 1, -8);
        check(ALU_SRA , -16, 2, -4);
        check(ALU_SRA , 16, 2, 4);
        check(ALU_SRA , -1, 31, -1);

        check(ALU_SRL , 16, 1, 8);
        check(ALU_SRL , 16, 2, 4);
        check(ALU_SRL , -16, 2, 32'sh3ffffffc);
        check(ALU_SRL , 1, 31, 0);

        check(ALU_XOR , 32'hAA55AA55, 32'h55AA55AA, 32'hFFFFFFFF);
        check(ALU_XOR , 32'hFFFFFFFF, 32'hFFFFFFFF, 0);

        check(ALU_OR  , 32'hAA55AA55, 32'h55AA55AA, 32'hFFFFFFFF);
        check(ALU_OR  , 0, 0, 0);

        check(ALU_AND , 32'hFFFFFFFF, 32'h12345678, 32'h12345678);
        check(ALU_AND , 32'hAAAAAAAA, 32'h55555555, 0);

        aluOperation = alu_op_t'(4'b1111);
        operand_1    = 123;
        operand_2    = 456;

        #1;

        assert(result === 123)
        else
            $error("FAIL default case");

        $display("PASSED all test");
        $finish;
    end

endmodule