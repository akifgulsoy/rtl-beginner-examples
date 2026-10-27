`timescale 1ns/1ps

module tb_binary_to_bcd;
    localparam int WIDTH  = 8;
    localparam int DIGITS = 3;

    logic [WIDTH-1:0]    binary;
    logic [DIGITS*4-1:0] bcd;
    integer              value;
    integer              hundreds;
    integer              tens;
    integer              ones;
    logic [DIGITS*4-1:0] expected_bcd;

    binary_to_bcd #(
        .WIDTH(WIDTH),
        .DIGITS(DIGITS)
    ) dut (
        .binary(binary),
        .bcd(bcd)
    );

    initial begin
        // Exhaustively check every 8-bit value against its decimal digits.
        for (value = 0; value < 2**WIDTH; value = value + 1) begin
            binary   = value[WIDTH-1:0];
            hundreds = value / 100;
            tens     = (value / 10) % 10;
            ones     = value % 10;
            expected_bcd = {hundreds[3:0], tens[3:0], ones[3:0]};
            #1;

            if (bcd !== expected_bcd)
                $fatal(1, "%0d: expected BCD %h, got %h", value, expected_bcd, bcd);
        end

        $display("PASS: binary_to_bcd");
        $finish;
    end
endmodule
