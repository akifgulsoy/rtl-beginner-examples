`timescale 1ns/1ps

module tb_up_down_counter;
    logic clk = 1'b0;
    logic reset;
    logic enable;
    logic up;
    logic [2:0] count;

    up_down_counter #(
        .WIDTH(3)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .up(up),
        .count(count)
    );

    always #5 clk = ~clk;

    task automatic tick_and_check(input logic [2:0] expected);
        @(posedge clk);
        #1;
        if (count !== expected)
            $fatal(1, "Expected count=%0d, got %0d", expected, count);
    endtask

    initial begin
        reset  = 1'b1;
        enable = 1'b0;
        up     = 1'b1;
        tick_and_check(3'd0);
        reset = 1'b0;

        // Count upward, then reverse direction.
        enable = 1'b1;
        tick_and_check(3'd1);
        tick_and_check(3'd2);
        tick_and_check(3'd3);
        up = 1'b0;
        tick_and_check(3'd2);
        tick_and_check(3'd1);

        // A disabled cycle holds its value.
        enable = 1'b0;
        tick_and_check(3'd1);

        // Decrementing zero wraps to the largest unsigned value.
        enable = 1'b1;
        tick_and_check(3'd0);
        tick_and_check(3'd7);

        // Incrementing the largest value wraps back to zero.
        up = 1'b1;
        tick_and_check(3'd0);

        $display("PASS: up_down_counter");
        $finish;
    end
endmodule
