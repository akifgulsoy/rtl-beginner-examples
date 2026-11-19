`timescale 1ns/1ps

module tb_unsigned_subtractor;
    logic [3:0] a, b, difference;
    logic borrow_in, borrow_out;
    logic one_bit_difference, one_bit_borrow;
    int expected;
    int one_bit_expected;

    unsigned_subtractor #(.WIDTH(4)) dut (
        .a(a), .b(b), .borrow_in(borrow_in),
        .difference(difference), .borrow_out(borrow_out)
    );

    unsigned_subtractor #(.WIDTH(1)) one_bit_dut (
        .a(a[0]), .b(b[0]), .borrow_in(borrow_in),
        .difference(one_bit_difference), .borrow_out(one_bit_borrow)
    );

    initial begin
        // Exhaust all 512 cases, including 0 - 15 - 1 and equal operands.
        for (int x = 0; x < 16; x++) begin
            for (int y = 0; y < 16; y++) begin
                for (int borrow = 0; borrow < 2; borrow++) begin
                    a = 4'(x);
                    b = 4'(y);
                    borrow_in = 1'(borrow);
                    expected = x - y - borrow;
                    one_bit_expected = (x % 2) - (y % 2) - borrow;
                    #1;
                    // Compare wrapped data and underflow separately.
                    if (difference !== 4'(expected) ||
                        borrow_out !== (expected < 0))
                        $fatal(1, "%0d - %0d - %0d: difference=%0d borrow=%b, expected %0d borrow=%b",
                               x, y, borrow, difference, borrow_out,
                               4'(expected), (expected < 0));

                    if (one_bit_difference !== 1'(one_bit_expected) ||
                        one_bit_borrow !== (one_bit_expected < 0))
                        $fatal(1, "Incorrect WIDTH=1 subtraction for %0d - %0d - %0d",
                               x % 2, y % 2, borrow);
                end
            end
        end

        $display("PASS: unsigned_subtractor");
        $finish;
    end
endmodule
