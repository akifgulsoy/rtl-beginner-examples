module binary_to_bcd #(
    parameter int WIDTH  = 8,
    parameter int DIGITS = 3
) (
    input  logic [WIDTH-1:0]    binary,
    output logic [DIGITS*4-1:0] bcd
);
    integer bit_index;
    integer digit_index;

    always_comb begin
        bcd = '0;

        // The shift-add-3 (double-dabble) algorithm converts one binary bit
        // per iteration. Each BCD digit at five or above needs a correction
        // before the next left shift.
        for (bit_index = WIDTH - 1; bit_index >= 0; bit_index = bit_index - 1) begin
            for (digit_index = 0; digit_index < DIGITS; digit_index = digit_index + 1) begin
                if (bcd[digit_index*4 +: 4] >= 4'd5)
                    bcd[digit_index*4 +: 4] = bcd[digit_index*4 +: 4] + 4'd3;
            end

            bcd = {bcd[DIGITS*4 - 2:0], binary[bit_index]};
        end
    end
endmodule
