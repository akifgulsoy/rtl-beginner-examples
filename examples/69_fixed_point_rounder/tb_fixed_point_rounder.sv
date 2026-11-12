`timescale 1ns/1ps

module tb_fixed_point_rounder;
    logic [5:0] value;
    logic [4:0] rounded;
    logic [1:0] narrow_value;
    logic [1:0] narrow_rounded;

    fixed_point_rounder #(.WHOLE_WIDTH(4), .FRAC_BITS(2)) dut (
        .value(value), .rounded(rounded)
    );

    fixed_point_rounder #(.WHOLE_WIDTH(1), .FRAC_BITS(1)) narrow_dut (
        .value(narrow_value), .rounded(narrow_rounded)
    );

    task automatic check_rounding(input logic [5:0] data, input logic [4:0] expected);
        value = data;
        #1;
        if (rounded !== expected)
            $fatal(1, "Input bits %b: expected %0d, got %0d", data, expected, rounded);
    endtask

    task automatic check_narrow(input logic [1:0] data, input logic [1:0] expected);
        narrow_value = data;
        #1;
        if (narrow_rounded !== expected)
            $fatal(1, "One fractional bit, input %b: expected %0d, got %0d",
                   data, expected, narrow_rounded);
    endtask

    initial begin
        // The underscore separates the integer and fractional bits.
        check_rounding(6'b0000_00, 5'd0);  // 0.00
        check_rounding(6'b0011_00, 5'd3);  // 3.00 stays odd.
        check_rounding(6'b0001_01, 5'd1);  // 1.25 rounds down.
        check_rounding(6'b0001_10, 5'd2);  // 1.50 rounds up to even.
        check_rounding(6'b0010_10, 5'd2);  // 2.50 rounds down to even.
        check_rounding(6'b0010_11, 5'd3);  // 2.75 rounds up.
        check_rounding(6'b1111_01, 5'd15); // 15.25 rounds down.
        check_rounding(6'b1111_10, 5'd16); // 15.50 uses the extra output bit.
        check_rounding(6'b1111_11, 5'd16); // 15.75 also uses the extra bit.

        check_narrow(2'b00, 2'd0);
        check_narrow(2'b01, 2'd0);
        check_narrow(2'b10, 2'd1);
        check_narrow(2'b11, 2'd2);

        $display("PASS: fixed_point_rounder");
        $finish;
    end
endmodule
