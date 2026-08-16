`timescale 1ns/1ps

module tb_logical_shifter;
    localparam int WIDTH = 8;

    logic [WIDTH-1:0] data_in;
    logic [$clog2(WIDTH):0] shift_amount;
    logic             shift_right;
    logic [WIDTH-1:0] data_out;

    logical_shifter #(.WIDTH(WIDTH)) dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    task automatic check_shift(
        input logic [WIDTH-1:0] value,
        input logic [$clog2(WIDTH):0] amount,
        input logic direction
    );
        logic [WIDTH-1:0] expected;

        data_in = value;
        shift_amount = amount;
        shift_right = direction;
        expected = direction ? (value >> amount) : (value << amount);
        #1;

        if (data_out !== expected)
            $fatal(1, "value=%b amount=%0d direction=%b: expected %b, got %b",
                   value, amount, direction, expected, data_out);
    endtask

    initial begin
        // Cover no shift, both directions, and shifts that clear all bits.
        check_shift(8'b1011_0011, 0, 1'b0);
        check_shift(8'b1011_0011, 1, 1'b0);
        check_shift(8'b1011_0011, 3, 1'b0);
        check_shift(8'b1011_0011, 1, 1'b1);
        check_shift(8'b1011_0011, 4, 1'b1);
        check_shift(8'b1011_0011, WIDTH, 1'b0);
        check_shift(8'b1011_0011, WIDTH, 1'b1);

        $display("PASS: logical_shifter");
        $finish;
    end
endmodule
