`timescale 1ns/1ps

module tb_windowed_sum;
    logic clk = 1'b0;
    logic reset = 1'b1;
    logic enable = 1'b0;
    logic [3:0] sample = '0;
    logic [5:0] sum;
    logic valid;
    logic [3:0] single_sum;
    logic single_valid;
    logic [3:0] expected_single_sum = '0;

    windowed_sum #(.WIDTH(4), .WINDOW_SIZE(3)) dut (
        .clk(clk), .reset(reset), .enable(enable), .sample(sample),
        .sum(sum), .valid(valid)
    );

    windowed_sum #(.WIDTH(4), .WINDOW_SIZE(1)) single_sample_dut (
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
        step(0, 1, 15, 0,  0, "first sample");
        step(0, 1, 15, 0,  0, "second sample");
        step(0, 0,  1, 0,  0, "disabled cycle does not finish the window");
        step(0, 1, 15, 1, 45, "third sample publishes a widened sum");
        step(0, 1,  2, 0, 45, "next window starts on the next edge");
        step(0, 1,  0, 0, 45, "zero is an accepted sample");
        step(0, 1,  4, 1,  6, "second sum excludes the first window");
        step(0, 0, 15, 0,  6, "valid clears even when disabled");
        step(0, 1, 15, 0,  6, "start a partial window");
        step(1, 1, 15, 0,  0, "reset discards the partial window and wins over enable");
        step(0, 1,  1, 0,  0, "first sample after reset");
        step(0, 1,  2, 0,  0, "second sample after reset");
        step(0, 1,  3, 1,  6, "third sample finishes the fresh window");

        $display("PASS: windowed_sum");
        $finish;
    end
endmodule
