// A parameterized shift register for the Path History Register
// It shifts in a hash of a new branch address on each update

import global_parameters::*;

module path_history_register (
    input logic                                                               clk,
    input logic                                                               rst,
    input logic                                                               update_enable,
    input logic [PATH_HISTORY_HASH_WIDTH-1:0]                                 new_pc_hash,
    
    output logic [PATH_HISTORY_NUM_ENTRIES-1:0][PATH_HISTORY_HASH_WIDTH-1:0]  path_history_out
);

    // Internal register to hold the path history state
    logic [PATH_HISTORY_NUM_ENTRIES-1:0][PATH_HISTORY_HASH_WIDTH-1:0] path_history_reg;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            // Reset path history to a known value of all zeros
            path_history_reg <= '0;
        end else if (update_enable) begin
            // Shift existing history to the left by one hash
            // Add in the new hash at index[0]
            path_history_reg <= {path_history_reg[PATH_HISTORY_NUM_ENTRIES-2:0], new_pc_hash};
        end
    end

    // Assign the internal register to the output port
    assign path_history_out = path_history_reg;

endmodule
