`timescale 1ns/1ps

module tb_bit_rotator;
    localparam int WIDTH = 8;

    logic [WIDTH-1:0] data_in;
    logic [$clog2(WIDTH):0] rotate_amount;
    logic             rotate_right;
    logic [WIDTH-1:0] data_out;

    bit_rotator #(.WIDTH(WIDTH)) dut (
        .data_in(data_in),
        .rotate_amount(rotate_amount),
        .rotate_right(rotate_right),
        .data_out(data_out)
    );

    task automatic check_rotation(
        input logic [WIDTH-1:0] value,
        input logic [$clog2(WIDTH):0] requested_amount,
        input logic direction
    );
        int unsigned amount;
        logic [WIDTH-1:0] expected;

        data_in = value;
        rotate_amount = requested_amount;
        rotate_right = direction;
        amount = requested_amount % WIDTH;
        expected = direction ?
                   ((value >> amount) | (value << (WIDTH - amount))) :
                   ((value << amount) | (value >> (WIDTH - amount)));
        #1;

        if (data_out !== expected)
            $fatal(1, "value=%b amount=%0d direction=%b: expected %b, got %b",
                   value, requested_amount, direction, expected, data_out);
    endtask

    initial begin
        // Cover both directions, no rotation, and amounts that wrap at WIDTH.
        check_rotation(8'b1011_0011, 0,     1'b0);
        check_rotation(8'b1011_0011, 1,     1'b0);
        check_rotation(8'b1011_0011, 3,     1'b0);
        check_rotation(8'b1011_0011, 1,     1'b1);
        check_rotation(8'b1011_0011, 5,     1'b1);
        check_rotation(8'b1011_0011, WIDTH, 1'b0);
        check_rotation(8'b1011_0011, WIDTH, 1'b1);
        check_rotation(8'b1011_0011, 9,     1'b0);
        check_rotation(8'b1011_0011, 9,     1'b1);

        $display("PASS: bit_rotator");
        $finish;
    end
endmodule
