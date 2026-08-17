`timescale 1ns/1ps

module tb_arithmetic_right_shifter;
    localparam int WIDTH = 8;

    logic signed [WIDTH-1:0] data_in;
    logic [$clog2(WIDTH):0]  shift_amount;
    logic signed [WIDTH-1:0] data_out;

    arithmetic_right_shifter #(.WIDTH(WIDTH)) dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );

    task automatic check_shift(
        input logic signed [WIDTH-1:0] value,
        input logic [$clog2(WIDTH):0] amount
    );
        logic signed [WIDTH-1:0] expected;

        data_in = value;
        shift_amount = amount;
        expected = value >>> amount;
        #1;

        if (data_out !== expected)
            $fatal(1, "value=%b amount=%0d: expected %b, got %b",
                   value, amount, expected, data_out);
    endtask

    initial begin
        // Positive values fill with zeros; negative values retain their sign.
        check_shift(8'sb0101_1000, 0);
        check_shift(8'sb0101_1000, 3);
        check_shift(-8'sd40, 1);
        check_shift(-8'sd40, 4);
        check_shift(-8'sd1, WIDTH);
        check_shift(8'sd85, WIDTH);

        $display("PASS: arithmetic_right_shifter");
        $finish;
    end
endmodule
