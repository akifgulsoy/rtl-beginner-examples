`timescale 1ns/1ps

module tb_rising_edge_detector;
    logic clk = 1'b0;
    logic rst;
    logic signal_in;
    logic rising_edge;

    rising_edge_detector dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .rising_edge(rising_edge)
    );

    always #5 clk = ~clk;

    task automatic check_pulse(input logic expected);
        #1;
        if (rising_edge !== expected)
            $fatal(1, "Expected rising_edge=%b, got %b", expected, rising_edge);
    endtask

    task automatic sample_input(input logic value, input logic expected_pulse);
        @(negedge clk);
        signal_in = value;
        @(posedge clk);
        check_pulse(expected_pulse);
    endtask

    initial begin
        rst = 1'b1;
        signal_in = 1'b0;
        @(posedge clk);
        check_pulse(1'b0);

        @(negedge clk);
        rst = 1'b0;

        sample_input(1'b0, 1'b0);
        sample_input(1'b1, 1'b1);
        sample_input(1'b1, 1'b0);
        sample_input(1'b0, 1'b0);
        sample_input(1'b1, 1'b1);

        $display("PASS: rising_edge_detector");
        $finish;
    end
endmodule
