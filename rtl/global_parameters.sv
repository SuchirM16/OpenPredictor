package global_parameters;
    // General
    parameter PC_WIDTH = 64;

    //History Parameters
    parameter GLOBAL_HISTORY_WIDTH = 128; // The length of the physical GHR
    parameter EFFECTIVE_HISTORY_WIDTH = 64; // The folded length to be computed with the perceptron
    parameter PATH_HISTORY_NUM_ENTRIES = 32; 
    parameter PATH_HISTORY_HASH_WIDTH = 8; // The width of the hash of the pc used for path history

    // Main Perceptron Table Parameters (excluding bias)
    parameter NUM_TABLES = 4; // Multiple skewed tables to minimize aliasing
    parameter PERCEPTRON_TABLE_NUM_ENTRIES = 2048;
    parameter PERCEPTRON_NUM_WEIGHTS = EFFECTIVE_HISTORY_WIDTH; // The number of weights w1 to wn correspond to the effective history width
    parameter PERCEPTRON_WEIGHT_WIDTH = 5;

    // Bias Perceptron Table Parameters
    parameter BIAS_TABLE_NUM_ENTRIES = 1024; // A smaller, more resource efficient table for w0 bias weights
    parameter BIAS_WEIGHT_WIDTH = PERCEPTRON_WEIGHT_WIDTH; // Kept the same for consistency

    // Prediction Parameters
    parameter Y_OUT_WIDTH = 12;

    // Training Parameters
    parameter THRESHOLD_WIDTH = 6;

endpackage