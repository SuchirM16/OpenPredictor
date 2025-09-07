// A memory module that stores the perceptron and bias weights.
// It supports parallel reads for prediction and a single sequential write for training.

import global_parameters::*;

module perceptron_table (
    // Inputs for prediction (parallel reads)
    input  logic                                                                            clk,
    input  logic                                                                            rst,
    input  logic [NUM_TABLES-1:0][($clog2(PERCEPTRON_TABLE_NUM_ENTRIES))-1:0]               read_addrs,
    input  logic [($clog2(BIAS_TABLE_NUM_ENTRIES))-1:0]                                     bias_read_addr,

    // Inputs for training (sequential write)
    input  logic                                                                            write_enable,
    input  logic [($clog2(NUM_TABLES))-1:0]                                                 write_table_idx,
    input  logic [($clog2(PERCEPTRON_TABLE_NUM_ENTRIES))-1:0]                               write_addr,
    input  logic [PERCEPTRON_NUM_WEIGHTS-1:0][PERCEPTRON_WEIGHT_WIDTH-1:0]                  write_data,

    // Inputs for bias training
    input  logic                                                                            bias_write_enable,
    input  logic [($clog2(BIAS_TABLE_NUM_ENTRIES))-1:0]                                     bias_write_addr,
    input  logic [BIAS_WEIGHT_WIDTH-1:0]                                                    bias_write_data,

    // Outputs for prediction
    output logic [NUM_TABLES-1:0][PERCEPTRON_NUM_WEIGHTS-1:0][PERCEPTRON_WEIGHT_WIDTH-1:0]  read_data,
    output logic [BIAS_WEIGHT_WIDTH-1:0]                                                    bias_read_data
);

    // Memory for the main perceptron tables.
    // The dimensions are: [table_index][entry_index][weight_index][weight_width]
    logic [NUM_TABLES-1:0]
          [PERCEPTRON_TABLE_NUM_ENTRIES-1:0]
          [PERCEPTRON_NUM_WEIGHTS-1:0]
          [PERCEPTRON_WEIGHT_WIDTH-1:0] perceptron_weights;

    // Memory for the separate bias table.
    logic [BIAS_TABLE_NUM_ENTRIES-1:0][BIAS_WEIGHT_WIDTH-1:0] bias_weights;

    // Parallel read logic (combinatorial)
    // For each of the four tables, we read the entire row of weights at the given address.
    genvar i;
    generate
        for (i = 0; i < NUM_TABLES; i++) begin
            assign read_data[i] = perceptron_weights[i][read_addrs[i]];
        end
    endgenerate

    // Combinatorial read for the bias table
    assign bias_read_data = bias_weights[bias_read_addr];

    // Sequential write logic (synchronous)
    // Handles the training updates for both the main and bias tables.
    always_ff @(posedge clk) begin
        if (write_enable) begin
            // We use the write_table_idx to select the correct table
            perceptron_weights[write_table_idx][write_addr] <= write_data;
        end
        if (bias_write_enable) begin
            bias_weights[bias_write_addr] <= bias_write_data;
        end
    end
endmodule