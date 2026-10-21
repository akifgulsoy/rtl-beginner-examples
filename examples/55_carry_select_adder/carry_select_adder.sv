module carry_select_adder (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       carry_in,
    output logic [3:0] sum,
    output logic       carry_out
);
    logic [2:0] lower_result;
    logic [2:0] upper_if_carry_clear;
    logic [2:0] upper_if_carry_set;

    // The lower block calculates the real carry into the upper block.
    assign lower_result = {1'b0, a[1:0]} + {1'b0, b[1:0]} + carry_in;

    // The upper block calculates both possible answers in parallel.
    assign upper_if_carry_clear = {1'b0, a[3:2]} + {1'b0, b[3:2]};
    assign upper_if_carry_set   = {1'b0, a[3:2]} + {1'b0, b[3:2]} + 1'b1;

    // Select the already-calculated upper result when the lower carry arrives.
    assign {carry_out, sum[3:2]} = lower_result[2] ? upper_if_carry_set
                                                    : upper_if_carry_clear;
    assign sum[1:0] = lower_result[1:0];
endmodule
