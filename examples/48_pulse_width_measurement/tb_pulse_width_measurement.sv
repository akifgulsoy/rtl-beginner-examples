`timescale 1ns/1ps

module tb_pulse_width_measurement;
    logic clk = 1'b0;
    logic reset;
    logic signal_in;
    logic [3:0] pulse_width;
    logic width_valid;

    pulse_width_measurement #(.WIDTH(4)) dut (
        .clk(clk),
        .reset(reset),
        .signal_in(signal_in),
        .pulse_width(pulse_width),
        .width_valid(width_valid)
    );

    always #5 clk = ~clk;

    task automatic expect_result(
        input logic [3:0] expected_width,
        input logic expected_valid,
        input string label
    );
        #1;
        if (pulse_width !== expected_width || width_valid !== expected_valid)
            $fatal(1, "%s: expected width=%0d valid=%b, got width=%0d valid=%b",
                   label, expected_width, expected_valid, pulse_width, width_valid);
    endtask

    initial begin
        reset = 1'b1;
        signal_in = 1'b0;
        @(posedge clk);
        expect_result(4'd0, 1'b0, "reset clears outputs");

        @(negedge clk);
        reset = 1'b0;

        // A three-clock high pulse is captured when its falling sample arrives.
        signal_in = 1'b1;
        @(posedge clk);
        expect_result(4'd0, 1'b0, "first high cycle starts measurement");
        @(posedge clk);
        expect_result(4'd0, 1'b0, "second high cycle extends measurement");
        @(posedge clk);
        expect_result(4'd0, 1'b0, "third high cycle extends measurement");
        @(negedge clk);
        signal_in = 1'b0;
        @(posedge clk);
        expect_result(4'd3, 1'b1, "three-cycle width captured");
        @(posedge clk);
        expect_result(4'd3, 1'b0, "valid is a one-clock pulse");

        // A new one-clock pulse overwrites the result only when it completes.
        @(negedge clk);
        signal_in = 1'b1;
        @(posedge clk);
        expect_result(4'd3, 1'b0, "new pulse leaves prior result available");
        @(negedge clk);
        signal_in = 1'b0;
        @(posedge clk);
        expect_result(4'd1, 1'b1, "one-cycle width captured");

        $display("PASS: pulse_width_measurement");
        $finish;
    end
endmodule
