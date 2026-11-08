`timescale 1ns/1ps

module tb_min_max_tracker;
    logic clk = 1'b0;
    logic reset = 1'b1;
    logic enable = 1'b0;
    logic [3:0] sample = '0;
    logic valid;
    logic [3:0] minimum;
    logic [3:0] maximum;

    min_max_tracker #(.WIDTH(4)) dut (
        .clk(clk), .reset(reset), .enable(enable), .sample(sample),
        .valid(valid), .minimum(minimum), .maximum(maximum)
    );

    always #5 clk = ~clk;

    task automatic step(
        input logic rst,
        input logic en,
        input logic [3:0] data,
        input logic expected_valid,
        input logic [3:0] expected_min,
        input logic [3:0] expected_max,
        input string label
    );
        @(negedge clk);
        reset = rst;
        enable = en;
        sample = data;
        @(posedge clk);
        #1;
        if ({valid, minimum, maximum} !==
            {expected_valid, expected_min, expected_max})
            $fatal(1, "%s: expected valid/min/max=%b/%d/%d, got %b/%d/%d",
                   label, expected_valid, expected_min, expected_max,
                   valid, minimum, maximum);
    endtask

    initial begin
        step(1, 0,  0, 0, 0,  0, "reset clears state");
        step(0, 0, 15, 0, 0,  0, "disabled sample cannot initialize limits");
        step(0, 1,  7, 1, 7,  7, "first sample seeds both limits");
        step(0, 1,  3, 1, 3,  7, "smaller sample lowers minimum");
        step(0, 1, 12, 1, 3, 12, "larger sample raises maximum");
        step(0, 1,  8, 1, 3, 12, "interior sample preserves limits");
        step(0, 1,  3, 1, 3, 12, "equal minimum preserves limits");
        step(0, 1, 12, 1, 3, 12, "equal maximum preserves limits");
        step(0, 0,  0, 1, 3, 12, "disabled lower sample is ignored");
        step(0, 0, 15, 1, 3, 12, "disabled higher sample is ignored");
        step(1, 1, 15, 0, 0,  0, "reset wins over enabled sample");
        step(0, 1,  9, 1, 9,  9, "first sample after reset replaces old limits");
        step(0, 1,  0, 1, 0,  9, "unsigned lower boundary");
        step(0, 1, 15, 1, 0, 15, "unsigned upper boundary");

        $display("PASS: min_max_tracker");
        $finish;
    end
endmodule
