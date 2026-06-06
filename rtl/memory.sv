module memory #(
    parameter int WORD_BYTES    = 4,
    parameter int ADDR_WIDTH    = 32,
    parameter int DEPTH_WORDS   = 256,
    parameter string INIT_FILE  = ""
)(
    input  logic clk,
    input  logic memoryWrite,
    input  logic memoryRead, 
    input  logic [WORD_BYTES*8-1:0] memoryWriteData,
    input  logic [ADDR_WIDTH-1:0] memoryAddress, 
    output logic [WORD_BYTES*8-1:0] memoryOutData
);

    localparam int DATA_WIDTH = WORD_BYTES * 8;
    localparam int WORD_SHIFT = $clog2(WORD_BYTES);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH_WORDS-1];

    logic [$clog2(DEPTH_WORDS)-1:0] word_addr;

    assign word_addr = memoryAddress[WORD_SHIFT + $clog2(DEPTH_WORDS)-1 : WORD_SHIFT];

    initial begin
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, mem);
    end

    always @(posedge clk) begin  //perguntar para o João pq se trocar para always_ff da erro
        if (memoryWrite)
            mem[word_addr] <= memoryWriteData;
    end

    always_comb begin
        if (memoryRead)
            memoryOutData = mem[word_addr];
        else
            memoryOutData = '0;
    end

endmodule