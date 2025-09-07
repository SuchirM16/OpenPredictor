// comparator.sv
//
// Compares the final prediction sum 'y' to a threshold to produce a
// binary prediction (taken or not taken).

import global_parameters::*;

module comparator
(
    // Input is the signed sum from the adder tree
    input  logic signed [Y_OUT_WIDTH-1:0] y_in,

    // Output is the binary prediction
    output logic                         prediction_out
);

    // The prediction is based on the sign of the y_in value.
    // If y_in >= 0, the prediction is 'taken' (1).
    // If y_in < 0, the prediction is 'not taken' (0).
    // The most significant bit (MSB) of a signed number indicates its sign.
    assign prediction_out = ~y_in[Y_OUT_WIDTH-1];

endmodule