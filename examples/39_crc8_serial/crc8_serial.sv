module crc8_serial #(
    parameter logic [7:0] POLYNOMIAL = 8'h07
) (
    input  logic       clk,
    input  logic       reset,
    input  logic       clear,
    input  logic       enable,
    input  logic       data_bit,
    output logic [7:0] crc
);
    logic feedback;

    // For an MSB-first CRC, the outgoing top bit is XORed with the next
    // input bit.  That feedback decides whether the polynomial is applied.
    assign feedback = crc[7] ^ data_bit;

    always_ff @(posedge clk) begin
        if (reset || clear)
            crc <= 8'h00;
        else if (enable)
            crc <= {crc[6:0], 1'b0} ^ (feedback ? POLYNOMIAL : 8'h00);
    end
endmodule
