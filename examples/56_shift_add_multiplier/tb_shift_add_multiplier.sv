`timescale 1ns/1ps

module tb_shift_add_multiplier;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0]   multiplicand;
    logic [WIDTH-1:0]   multiplier;
    logic [2*WIDTH-1:0] product;
    logic [2*WIDTH-1:0] expected_product;
    integer             x;
    integer             y;

    shift_add_multiplier #(.WIDTH(WIDTH)) dut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

    initial begin
        // Every input pair checks zero, single-bit, and multi-bit partial sums.
        for (x = 0; x < 2**WIDTH; x = x + 1) begin
            for (y = 0; y < 2**WIDTH; y = y + 1) begin
                multiplicand = x[WIDTH-1:0];
                multiplier = y[WIDTH-1:0];
                expected_product = x * y;
                #1;
                if (product !== expected_product)
                    $fatal(1, "%0d * %0d: expected %0d, got %0d",
                           x, y, expected_product, product);
            end
        end

        $display("PASS: shift_add_multiplier");
        $finish;
    end
endmodule
