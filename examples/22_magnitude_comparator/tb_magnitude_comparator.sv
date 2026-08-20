`timescale 1ns/1ps

module tb_magnitude_comparator;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic             a_less_b;
    logic             a_equal_b;
    logic             a_greater_b;

    magnitude_comparator #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .a_less_b(a_less_b),
        .a_equal_b(a_equal_b),
        .a_greater_b(a_greater_b)
    );

    task automatic check_pair(
        input logic [WIDTH-1:0] first,
        input logic [WIDTH-1:0] second
    );
        logic expected_less;
        logic expected_equal;
        logic expected_greater;

        a = first;
        b = second;
        expected_less    = first < second;
        expected_equal   = first == second;
        expected_greater = first > second;
        #1;

        if ({a_less_b, a_equal_b, a_greater_b} !==
            {expected_less, expected_equal, expected_greater})
            $fatal(1, "a=%0d b=%0d: comparison outputs were %b%b%b",
                   first, second, a_less_b, a_equal_b, a_greater_b);
    endtask

    initial begin
        // Cover every ordered pair, including equal values and the end points.
        for (int first = 0; first < 2**WIDTH; first++) begin
            for (int second = 0; second < 2**WIDTH; second++) begin
                check_pair(first[WIDTH-1:0], second[WIDTH-1:0]);
            end
        end

        $display("PASS: magnitude_comparator");
        $finish;
    end
endmodule
