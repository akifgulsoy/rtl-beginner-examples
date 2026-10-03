module gray_to_binary #(
    parameter int WIDTH = 4
) (
    input  logic [WIDTH-1:0] gray,
    output logic [WIDTH-1:0] binary
);
    // The most-significant bit is unchanged; each lower bit accumulates XORs.
    always_comb begin
        binary[WIDTH-1] = gray[WIDTH-1];

        for (int index = WIDTH - 2; index >= 0; index--) begin
            binary[index] = binary[index + 1] ^ gray[index];
        end
    end
endmodule
