module signed_absolute_value #(
    parameter int WIDTH = 4
) (
    input  logic signed [WIDTH-1:0] value,
    output logic        [WIDTH-1:0] magnitude
);
    // The unsigned output can represent the magnitude of the most negative input.
    assign magnitude = value[WIDTH-1] ? $unsigned(-value) : $unsigned(value);
endmodule
