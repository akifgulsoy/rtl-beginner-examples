`timescale 1ns/1ps

module tb_sliding_window_sum;
    logic clk = 1'b0;
    logic reset = 1'b1;
    logic enable = 1'b0;
    logic [3:0] sample = '0;
    logic [5:0] sum;
    logic valid;
    logic [3:0] single_sum;
    logic single_valid;
    logic [3:0] expected_single_sum = '0;

    sliding_window_sum #(.WIDTH(4), .WINDOW_SIZE(3)) dut (
        .clk(clk), .reset(reset), .enable(enable), .sample(sample),
        .sum(sum), .valid(valid)
    );

    sliding_window_sum #(.WIDTH(4), .WINDOW_SIZE(1)) single_sample_dut (
        .clk(clk), .reset(reset), .enable(enable), .sample(sample),
        .sum(single_sum), .valid(single_valid)
    );

    always #5 clk = ~clk;

    task automatic step(
        input logic rst,
        input logic en,
        input logic [3:0] data,
        input logic expected_valid,
        input logic [5:0] expected_sum,
        input string label
    );
        @(negedge clk);
        reset = rst;
        enable = en;
        sample = data;
        if (rst)
            expected_single_sum = '0;
        else if (en)
            expected_single_sum = data;

        @(posedge clk);
        #1;
        if ({valid, sum} !== {expected_valid, expected_sum})
            $fatal(1, "%s: expected valid/sum=%b/%d, got %b/%d",
                   label, expected_valid, expected_sum, valid, sum);
        if ({single_valid, single_sum} !== {(en && !rst), expected_single_sum})
            $fatal(1, "%s: single-sample window expected valid/sum=%b/%d, got %b/%d",
                   label, en && !rst, expected_single_sum, single_valid, single_sum);
    endtask

    initial begin
        step(1, 0,  0, 0,  0, "reset clears outputs");
        step(0, 1, 15, 0, 15, "first sample contributes a partial sum");
        step(0, 1, 15, 0, 30, "second sample contributes a partial sum");
        step(0, 0,  8, 0, 30, "disabled cycle does not fill the window");
        step(0, 1, 15, 1, 45, "third sample fills the window at maximum total");
        step(0, 1,  1, 1, 31, "replace the oldest 15 with 1");
        step(0, 0,  9, 0, 31, "disabled cycle holds sum and write position");
        step(0, 1,  2, 1, 18, "replace the next 15 with 2");
        step(0, 1,  4, 1,  7, "replace the last 15 and wrap the index");
        step(0, 1,  0, 1,  6, "after wrap, replace 1 with 0");
        step(0, 1,  6, 1, 10, "replace 2 while keeping 4 and 0");
        step(1, 1, 15, 0,  0, "reset wins over enable on a full buffer");
        step(0, 1,  3, 0,  3, "refill ignores stale buffer contents");
        step(0, 1,  5, 0,  8, "two fresh samples remain a partial window");
        step(0, 1,  0, 1,  8, "zero counts as the third fresh sample");
        step(0, 1,  2, 1,  7, "refilled buffer evicts its first fresh sample");

        $display("PASS: sliding_window_sum");
        $finish;
    end
endmodule
