import global_parameters::*;

module hash_generator (
    input  logic [PC_WIDTH-1:0]                                                 pc_in,
    input  logic [GLOBAL_HISTORY_WIDTH-1:0]                                     ghr_in,
    input  logic [PATH_HISTORY_NUM_ENTRIES-1:0][PATH_HISTORY_HASH_WIDTH-1:0]    phr_in, // Fixed typo
    output logic [NUM_TABLES-1:0][($clog2(PERCEPTRON_TABLE_NUM_ENTRIES))-1:0]   read_addrs,
    output logic [($clog2(BIAS_TABLE_NUM_ENTRIES))-1:0]                         bias_read_addr
);

    localparam MAIN_TABLE_INDEX_WIDTH = $clog2(PERCEPTRON_TABLE_NUM_ENTRIES); // 12 bits
    localparam BIAS_TABLE_INDEX_WIDTH = $clog2(BIAS_TABLE_NUM_ENTRIES); // 10 bits

    // Bias table hash: Use folded GHR and PC
    logic [63:0] ghr_folded;
    assign ghr_folded = ghr_in[63:0] ^ ghr_in[127:64]; // Fold to 64 bits for consistency
    assign bias_read_addr = pc_in[BIAS_TABLE_INDEX_WIDTH-1:0] ^ ghr_folded[BIAS_TABLE_INDEX_WIDTH-1:0];

    // Geometric history lengths for main tables
    localparam int HISTORY_LENGTHS [NUM_TABLES] = '{8, 16, 32, 64}; // Geometric lengths
    logic [MAIN_TABLE_INDEX_WIDTH-1:0] folded_ghr [NUM_TABLES];

    // Fold GHR to 12 bits for each table
    always_comb begin
        folded_ghr[0] = ghr_in[7:0] ^ {4'h0, ghr_in[7:0]}; // 8 bits
        folded_ghr[1] = ghr_in[15:0] ^ {ghr_in[15:4], 4'h0}; // 16 bits
        folded_ghr[2] = ghr_in[31:0] ^ {ghr_in[31:20], ghr_in[19:8], ghr_in[7:0]}; // 32 bits
        folded_ghr[3] = ghr_folded[11:0]; // 64 bits (use pre-folded GHR)
    end

    // Generate table indices
    genvar i;
    generate
        for (i = 0; i < NUM_TABLES; i++) begin
            assign read_addrs[i] = pc_in[i*MAIN_TABLE_INDEX_WIDTH +: MAIN_TABLE_INDEX_WIDTH] ^ // Different PC bits
                                   folded_ghr[i] ^ // Folded GHR
                                   {4{phr_in[i][7:0]}}; // Different path history entry
        end
    endgenerate

endmodule