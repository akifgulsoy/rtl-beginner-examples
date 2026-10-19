`timescale 1ns/1ps

module tb_ripple_carry_adder;
    logic [3:0] a, b, sum;
    logic carry_in, carry_out;
    logic [4:0] expected;

    ripple_carry_adder #(.WIDTH(4)) dut (
        .a(a), .b(b), .carry_in(carry_in), .sum(sum), .carry_out(carry_out)
    );

    initial begin
        // Exhaust all operand pairs and both carry-in values.
        for (int x = 0; x < 16; x++) begin
            for (int y = 0; y < 16; y++) begin
                for (int c = 0; c < 2; c++) begin
                    a = x;
                    b = y;
                    carry_in = c;
                    expected = x + y + c;
                    #1;
                    if ({carry_out, sum} !== expected)
                        $fatal(1, "%0d + %0d + %0d: expected %0d, got %0d",
                               x, y, c, expected, {carry_out, sum});
                end
            end
        end
        $display("PASS: ripple_carry_adder");
        $finish;
    end
endmodule
