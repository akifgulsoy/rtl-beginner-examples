module unsigned_divider #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] dividend,
    input  logic [WIDTH-1:0] divisor,
    output logic [WIDTH-1:0] quotient,
    output logic [WIDTH-1:0] remainder,
    output logic             divide_by_zero
);
    logic [WIDTH:0] partial_remainder;
    integer bit_index;

    always_comb begin
        quotient          = '0;
        remainder         = '0;
        divide_by_zero    = (divisor == '0);
        partial_remainder = '0;

        if (!divide_by_zero) begin
            // Bring down one dividend bit at a time, from MSB to LSB.
            for (bit_index = WIDTH - 1; bit_index >= 0; bit_index = bit_index - 1) begin
                partial_remainder = {partial_remainder[WIDTH-1:0], dividend[bit_index]};

                if (partial_remainder >= {1'b0, divisor}) begin
                    partial_remainder = partial_remainder - {1'b0, divisor};
                    quotient[bit_index] = 1'b1;
                end
            end

            remainder = partial_remainder[WIDTH-1:0];
        end
    end
endmodule
