module fixed_point_rounder #(
    parameter int WHOLE_WIDTH = 4,
    parameter int FRAC_BITS = 2
) (
    input  logic [WHOLE_WIDTH+FRAC_BITS-1:0] value,
    output logic [WHOLE_WIDTH:0]             rounded
);
    localparam logic [FRAC_BITS-1:0] HALF = {1'b1, {(FRAC_BITS-1){1'b0}}};

    logic [WHOLE_WIDTH-1:0] whole;
    logic [FRAC_BITS-1:0] fraction;
    logic round_up;

    assign whole = value[FRAC_BITS +: WHOLE_WIDTH];
    assign fraction = value[FRAC_BITS-1:0];

    // At exactly half, increment only an odd integer part.
    assign round_up = (fraction > HALF) || ((fraction == HALF) && whole[0]);

    // Keep the carry when rounding the largest integer part up.
    assign rounded = {1'b0, whole} + {{WHOLE_WIDTH{1'b0}}, round_up};
endmodule
