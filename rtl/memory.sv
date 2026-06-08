module memory #(
    parameter int WORD_BYTES    = 4,
    parameter int ADDR_WIDTH    = 32,
    parameter int DEPTH_WORDS   = 256,
    parameter int BASE_ADDR     = 32'h00000000,
    parameter string INIT_FILE  = "../tb/data/rv32ui-p-add.hex"
)(
    input  logic clk,
    input  logic memoryWrite,
    input  logic memoryRead, 
    input  logic [WORD_BYTES*8-1:0] memoryWriteData,
    output logic [WORD_BYTES*8-1:0] memoryReadData,
    input  logic [ADDR_WIDTH-1:0] memoryAddress
);

    localparam int DATA_WIDTH = WORD_BYTES * 8;
    localparam int WORD_SHIFT = $clog2(WORD_BYTES);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH_WORDS-1];
    logic [$clog2(DEPTH_WORDS)-1:0] word_addr;

    assign word_addr = (memoryAddress - BASE_ADDR) >> WORD_SHIFT;

    // init da memória a partir do arquivo .hex com endereços absolutos
    initial begin
        if (INIT_FILE != "") begin
            integer fd, code;
            integer addr;
            integer data;
            integer idx;
            string token;

            fd = $fopen(INIT_FILE, "r");
            if (fd == 0) begin
                $display("ERRO: não foi possível abrir %s", INIT_FILE);
                $finish;
            end

            addr = BASE_ADDR;
            while (!$feof(fd)) begin
                code = $fscanf(fd, "%s", token);
                if (code != 1) break;

                if (token[0] == "@") begin
                    $sscanf(token, "@%h", addr);
                end else begin
                    $sscanf(token, "%h", data);
                    idx = (addr - BASE_ADDR) >> WORD_SHIFT;
                    if (idx >= 0 && idx < DEPTH_WORDS)
                        mem[idx] = data;
                    else
                        $display("ERRO: endereço 0x%08h fora dos limites (DEPTH_WORDS=%0d)", addr, DEPTH_WORDS);
                    addr = addr + WORD_BYTES;
                end
            end
            $fclose(fd);
            $display("Memória inicializada a partir de %s (BASE_ADDR=0x%08h)", INIT_FILE, BASE_ADDR);
        end
    end

    always @(posedge clk) begin
        if (memoryWrite)
            mem[word_addr] <= memoryWriteData;
    end

    always_comb begin
        if (memoryRead)
            memoryReadData = mem[word_addr];
        else
            memoryReadData = '0;
    end

endmodule