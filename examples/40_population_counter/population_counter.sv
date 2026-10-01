module population_counter #(
    parameter int WIDTH = 8,
    parameter int COUNT_WIDTH = $clog2(WIDTH + 1)
) (
    input  logic [WIDTH-1:0]       data_in,
    output logic [COUNT_WIDTH-1:0] one_count
);
    integer bit_index;

    always_comb begin
        // Add one for each asserted bit in the input word.
        one_count = '0;

        for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1)
            one_count = one_count + data_in[bit_index];
    end
endmodule
