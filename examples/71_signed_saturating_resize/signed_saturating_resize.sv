module signed_saturating_resize #(
    parameter int IN_WIDTH  = 5,
    parameter int OUT_WIDTH = 3  // 1 <= OUT_WIDTH <= IN_WIDTH
) (
    input  logic signed [IN_WIDTH-1:0]  value,
    output logic signed [OUT_WIDTH-1:0] result
);
    localparam logic signed [OUT_WIDTH-1:0] MAX_VALUE = {1'b0, {(OUT_WIDTH-1){1'b1}}};
    localparam logic signed [OUT_WIDTH-1:0] MIN_VALUE = {1'b1, {(OUT_WIDTH-1){1'b0}}};

    // Both operands are signed, so comparisons sign-extend the limits.
    // Slice the input only after checking that it fits.
    assign result = (value > MAX_VALUE) ? MAX_VALUE :
                    (value < MIN_VALUE) ? MIN_VALUE : value[OUT_WIDTH-1:0];
endmodule
