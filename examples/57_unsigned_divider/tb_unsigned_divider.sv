`timescale 1ns/1ps

module tb_unsigned_divider;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0] dividend;
    logic [WIDTH-1:0] divisor;
    logic [WIDTH-1:0] quotient;
    logic [WIDTH-1:0] remainder;
    logic             divide_by_zero;
    integer           numerator;
    integer           denominator;

    unsigned_divider #(.WIDTH(WIDTH)) dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .divide_by_zero(divide_by_zero)
    );

    initial begin
        // Check the defined zero-divisor response separately from valid divisions.
        dividend = 4'd9;
        divisor = '0;
        #1;
        if (!divide_by_zero || quotient !== '0 || remainder !== '0)
            $fatal(1, "divide by zero: expected flag and zero outputs");

        // Exhaustively cover every valid 4-bit unsigned division.
        for (numerator = 0; numerator < 2**WIDTH; numerator = numerator + 1) begin
            for (denominator = 1; denominator < 2**WIDTH; denominator = denominator + 1) begin
                dividend = numerator[WIDTH-1:0];
                divisor = denominator[WIDTH-1:0];
                #1;
                if (divide_by_zero)
                    $fatal(1, "%0d / %0d: unexpected divide_by_zero", numerator, denominator);
                if (quotient !== numerator / denominator)
                    $fatal(1, "%0d / %0d: expected quotient %0d, got %0d",
                           numerator, denominator, numerator / denominator, quotient);
                if (remainder !== numerator % denominator)
                    $fatal(1, "%0d %% %0d: expected remainder %0d, got %0d",
                           numerator, denominator, numerator % denominator, remainder);
            end
        end

        $display("PASS: unsigned_divider");
        $finish;
    end
endmodule
