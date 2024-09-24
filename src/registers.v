module registers (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in
    output wire [31:0] register_source_1,
    output wire [31:0] register_source_2,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire redWrite
);

    reg x0  [31:0];
    reg x1  [31:0];
    reg x2  [31:0];
    reg x3  [31:0];
    reg x4  [31:0];
    reg x5  [31:0];
    reg x6  [31:0];
    reg x7  [31:0];
    reg x8  [31:0];
    reg x9  [31:0];
    reg x10 [31:0];
    reg x11 [31:0];
    reg x12 [31:0];
    reg x13 [31:0];
    reg x14 [31:0];
    reg x15 [31:0];
    reg x16 [31:0];
    reg x17 [31:0];
    reg x18 [31:0];
    reg x19 [31:0];
    reg x20 [31:0];
    reg x21 [31:0];
    reg x22 [31:0];
    reg x23 [31:0];
    reg x24 [31:0];
    reg x25 [31:0];
    reg x26 [31:0];
    reg x27 [31:0];
    reg x28 [31:0];
    reg x29 [31:0];
    reg x30 [31:0];
    reg x31 [31:0];
    reg trash [31:0];

initial begin
    x0  = 32'b0;
    x1  = 32'b0;
    x2  = 32'b0;
    x3  = 32'b0;
    x4  = 32'b0;
    x5  = 32'b0;
    x6  = 32'b0;
    x7  = 32'b0;
    x8  = 32'b0;
    x9  = 32'b0;
    x10 = 32'b0;
    x11 = 32'b0;
    x12 = 32'b0;
    x13 = 32'b0;
    x14 = 32'b0;
    x15 = 32'b0;
    x16 = 32'b0;
    x17 = 32'b0;
    x18 = 32'b0;
    x19 = 32'b0;
    x20 = 32'b0;
    x21 = 32'b0;
    x22 = 32'b0;
    x23 = 32'b0;
    x24 = 32'b0;
    x25 = 32'b0;
    x26 = 32'b0;
    x27 = 32'b0;
    x28 = 32'b0;
    x29 = 32'b0;
    x30 = 32'b0;
    x31 = 32'b0;
end

always @(posedge clk) begin
    if (rst) begin
        x0  = 32'b0;
        x1  = 32'b0;
        x2  = 32'b0;
        x3  = 32'b0;
        x4  = 32'b0;
        x5  = 32'b0;
        x6  = 32'b0;
        x7  = 32'b0;
        x8  = 32'b0;
        x9  = 32'b0;
        x10 = 32'b0;
        x11 = 32'b0;
        x12 = 32'b0;
        x13 = 32'b0;
        x14 = 32'b0;
        x15 = 32'b0;
        x16 = 32'b0;
        x17 = 32'b0;
        x18 = 32'b0;
        x19 = 32'b0;
        x20 = 32'b0;
        x21 = 32'b0;
        x22 = 32'b0;
        x23 = 32'b0;
        x24 = 32'b0;
        x25 = 32'b0;
        x26 = 32'b0;
        x27 = 32'b0;
        x28 = 32'b0;
        x29 = 32'b0;
        x30 = 32'b0;
        x31 = 32'b0;
    end else begin
        case(rs1) 
            5'b00000: register_source_1 <= x0;
            5'b00001: register_source_1 <= x1;
            5'b00010: register_source_1 <= x2;
            5'b00011: register_source_1 <= x3;
            5'b00100: register_source_1 <= x4;
            5'b00101: register_source_1 <= x5;
            5'b00110: register_source_1 <= x6;
            5'b00111: register_source_1 <= x7;
            5'b01000: register_source_1 <= x8;
            5'b01001: register_source_1 <= x9;
            5'b01010: register_source_1 <= x10;
            5'b01011: register_source_1 <= x11;
            5'b01100: register_source_1 <= x12;
            5'b01101: register_source_1 <= x13;
            5'b01110: register_source_1 <= x14;
            5'b01111: register_source_1 <= x15;
            5'b10000: register_source_1 <= x16;
            5'b10001: register_source_1 <= x17;
            5'b10010: register_source_1 <= x18;
            5'b10011: register_source_1 <= x19;
            5'b10100: register_source_1 <= x20;
            5'b10101: register_source_1 <= x21;
            5'b10110: register_source_1 <= x22;
            5'b10111: register_source_1 <= x23;
            5'b11000: register_source_1 <= x24;
            5'b11001: register_source_1 <= x25;
            5'b11010: register_source_1 <= x26;
            5'b11011: register_source_1 <= x27;
            5'b11100: register_source_1 <= x28;
            5'b11101: register_source_1 <= x29;
            5'b11110: register_source_1 <= x30;
            5'b11111: register_source_1 <= x31;
            default: register_source_1 = 32'b0;
        endcase
        case(rs2) 
            5'b00000: register_source_2 <= x0;
            5'b00001: register_source_2 <= x1;
            5'b00010: register_source_2 <= x2;
            5'b00011: register_source_2 <= x3;
            5'b00100: register_source_2 <= x4;
            5'b00101: register_source_2 <= x5;
            5'b00110: register_source_2 <= x6;
            5'b00111: register_source_2 <= x7;
            5'b01000: register_source_2 <= x8;
            5'b01001: register_source_2 <= x9;
            5'b01010: register_source_2 <= x10;
            5'b01011: register_source_2 <= x11;
            5'b01100: register_source_2 <= x12;
            5'b01101: register_source_2 <= x13;
            5'b01110: register_source_2 <= x14;
            5'b01111: register_source_2 <= x15;
            5'b10000: register_source_2 <= x16;
            5'b10001: register_source_2 <= x17;
            5'b10010: register_source_2 <= x18;
            5'b10011: register_source_2 <= x19;
            5'b10100: register_source_2 <= x20;
            5'b10101: register_source_2 <= x21;
            5'b10110: register_source_2 <= x22;
            5'b10111: register_source_2 <= x23;
            5'b11000: register_source_2 <= x24;
            5'b11001: register_source_2 <= x25;
            5'b11010: register_source_2 <= x26;
            5'b11011: register_source_2 <= x27;
            5'b11100: register_source_2 <= x28;
            5'b11101: register_source_2 <= x29;
            5'b11110: register_source_2 <= x30;
            5'b11111: register_source_2 <= x31;
            default: register_source_2 = 32'b0;
        endcase
        if (redWrite = 1'b1) begin
            case(rd)
            5'b00001: x1  <= data_in;
            5'b00010: x2  <= data_in;
            5'b00011: x3  <= data_in;
            5'b00100: x4  <= data_in;
            5'b00101: x5  <= data_in;
            5'b00110: x6  <= data_in;
            5'b00111: x7  <= data_in;
            5'b01000: x8  <= data_in;
            5'b01001: x9  <= data_in;
            5'b01010: x10 <= data_in;
            5'b01011: x11 <= data_in;
            5'b01100: x12 <= data_in;
            5'b01101: x13 <= data_in;
            5'b01110: x14 <= data_in;
            5'b01111: x15 <= data_in;
            5'b10000: x16 <= data_in;
            5'b10001: x17 <= data_in;
            5'b10010: x18 <= data_in;
            5'b10011: x19 <= data_in;
            5'b10100: x20 <= data_in;
            5'b10101: x21 <= data_in;
            5'b10110: x22 <= data_in;
            5'b10111: x23 <= data_in;
            5'b11000: x24 <= data_in;
            5'b11001: x25 <= data_in;
            5'b11010: x26 <= data_in;
            5'b11011: x27 <= data_in;
            5'b11100: x28 <= data_in;
            5'b11101: x29 <= data_in;
            5'b11110: x30 <= data_in;
            5'b11111: x31 <= data_in;
            default: trash <= data_in; //error
            endcase
        end
    end 

end

);
    
endmodule