module binary_to_gray #(
    parameter int WIDTH = 4
) (
    input  logic [WIDTH-1:0] binary,
    output logic [WIDTH-1:0] gray
);
    // Each Gray-code bit changes only when adjacent binary bits differ.
    assign gray = binary ^ (binary >> 1);
endmodule
