module leading_zero_counter #(
    parameter int WIDTH = 8,
    parameter int COUNT_WIDTH = $clog2(WIDTH + 1)
) (
    input  logic [WIDTH-1:0]       data_in,
    output logic [COUNT_WIDTH-1:0] leading_zero_count
);
    integer bit_index;

    always_comb begin
        // An all-zero word has WIDTH leading zeros.
        leading_zero_count = WIDTH;

        // Keep the first one found while scanning from the most-significant bit.
        for (bit_index = WIDTH - 1; bit_index >= 0; bit_index = bit_index - 1) begin
            if (data_in[bit_index] && leading_zero_count == WIDTH)
                leading_zero_count = WIDTH - 1 - bit_index;
        end
    end
endmodule
