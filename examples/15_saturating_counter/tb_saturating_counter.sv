`timescale 1ns/1ps

module tb_saturating_counter;
    logic clk = 1'b0;
    logic reset;
    logic enable;
    logic up;
    logic [2:0] count;

    saturating_counter #(
        .WIDTH(3)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .up(up),
        .count(count)
    );

    always #5 clk = ~clk;

    task automatic check_count(input logic [2:0] expected);
        #1;
        if (count !== expected)
            $fatal(1, "Expected count=%0d, got %0d", expected, count);
    endtask

    task automatic tick_and_check(input logic [2:0] expected);
        @(posedge clk);
        check_count(expected);
    endtask

    initial begin
        reset  = 1'b1;
        enable = 1'b0;
        up     = 1'b1;
        tick_and_check(3'd0);
        reset = 1'b0;

        // Count upward to the maximum value.
        enable = 1'b1;
        repeat (7) begin
            @(posedge clk);
        end
        check_count(3'd7);

        // An extra increment holds the maximum instead of wrapping to zero.
        tick_and_check(3'd7);

        // Count down to zero, then verify that an extra decrement holds zero.
        up = 1'b0;
        repeat (7) begin
            @(posedge clk);
        end
        check_count(3'd0);
        tick_and_check(3'd0);

        // Disabled cycles keep the current value unchanged.
        enable = 1'b0;
        tick_and_check(3'd0);

        $display("PASS: saturating_counter");
        $finish;
    end
endmodule
