// A simple, paramtererized shift register for the Global History Register
// It shifts every time a new branch outcome is received

import global_parameters::*;

module global_history_register (
    input logic                              clk,
    input logic                              rst,
    input logic                              update_enable,
    input logic                              new_branch_outcome, // 1 for Taken, 0 for Not Taken

    output logic [GLOBAL_HISTORY_WIDTH-1:0]  ghr_out
);

    // Internal register to hold the GHR state
    // Index [0] will be the most recent outcome
    // Index [GLOBAL_HISTORY_WIDTH-1] will be the oldest outcome stored
    logic [GLOBAL_HISTORY_WIDTH-1:0] ghr_reg;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            // Reset the Global History Register to a known state of all zeros
            ghr_reg <= '0;
        end else if (update_enable) begin
            // Shift the register left and insert the new outcome at the least significant bit
            ghr_reg <= {ghr_reg[GLOBAL_HISTORY_WIDTH-2:0], new_branch_outcome};
        end
    end

    // Assign the internal register to the output port
    assign ghr_out = ghr_reg;

endmodule