`timescale 1ns/1ps

module tb_signed_saturating_adder;
    logic signed [3:0] a, b, result;
    integer expected;

    signed_saturating_adder #(.WIDTH(4)) dut (.a(a), .b(b), .result(result));

    initial begin
        // All signed 4-bit operand pairs, including both overflow directions.
        for (int x = -8; x <= 7; x++) begin
            for (int y = -8; y <= 7; y++) begin
                a = x;
                b = y;
                expected = x + y;
                if (expected > 7) expected = 7;
                if (expected < -8) expected = -8;
                #1;
                if ($signed(result) !== expected)
                    $fatal(1, "%0d + %0d: expected %0d, got %0d", x, y, expected, $signed(result));
            end
        end
        $display("PASS: signed_saturating_adder");
        $finish;
    end
endmodule
