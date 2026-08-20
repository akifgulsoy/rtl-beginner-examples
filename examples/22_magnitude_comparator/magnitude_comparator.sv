module magnitude_comparator #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic             a_less_b,
    output logic             a_equal_b,
    output logic             a_greater_b
);
    // These operators compare the complete unsigned vectors, not individual bits.
    always_comb begin
        a_less_b    = a < b;
        a_equal_b   = a == b;
        a_greater_b = a > b;
    end
endmodule
