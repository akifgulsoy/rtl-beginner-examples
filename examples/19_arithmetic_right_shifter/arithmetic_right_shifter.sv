module arithmetic_right_shifter #(
    parameter int WIDTH = 8
) (
    input  logic signed [WIDTH-1:0] data_in,
    input  logic [$clog2(WIDTH):0]  shift_amount,
    output logic signed [WIDTH-1:0] data_out
);
    // An arithmetic right shift copies the sign bit into vacated positions.
    always_comb begin
        data_out = data_in >>> shift_amount;
    end
endmodule
