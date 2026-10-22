module shift_add_multiplier #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0]   multiplicand,
    input  logic [WIDTH-1:0]   multiplier,
    output logic [2*WIDTH-1:0] product
);
    integer bit_index;

    always_comb begin
        // Each set multiplier bit adds one shifted copy of the multiplicand.
        product = '0;

        for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1)
            if (multiplier[bit_index])
                product = product +
                          ({{WIDTH{1'b0}}, multiplicand} << bit_index);
    end
endmodule
