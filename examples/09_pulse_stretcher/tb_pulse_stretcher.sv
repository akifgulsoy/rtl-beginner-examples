`timescale 1ns/1ps

module tb_pulse_stretcher;
    logic clk = 1'b0;
    logic rst;
    logic pulse_in;
    logic pulse_out;

    pulse_stretcher #(.STRETCH_CYCLES(3)) dut (
        .clk(clk),
        .rst(rst),
        .pulse_in(pulse_in),
        .pulse_out(pulse_out)
    );

    always #5 clk = ~clk;

    task automatic check_output(input logic expected);
        #1;
        if (pulse_out !== expected)
            $fatal(1, "Expected pulse_out=%b, got %b", expected, pulse_out);
    endtask

    initial begin
        rst = 1'b1;
        pulse_in = 1'b0;
        @(posedge clk);
        check_output(1'b0);

        @(negedge clk);
        rst = 1'b0;
        pulse_in = 1'b1;
        @(posedge clk);
        check_output(1'b1);

        // The input is low again, but the output stays high for three clocks.
        @(negedge clk);
        pulse_in = 1'b0;
        @(posedge clk);
        check_output(1'b1);

        // A pulse while busy is ignored and does not restart the timer.
        @(negedge clk);
        pulse_in = 1'b1;
        @(posedge clk);
        check_output(1'b1);

        @(negedge clk);
        pulse_in = 1'b0;
        @(posedge clk);
        check_output(1'b0);

        $display("PASS: pulse_stretcher");
        $finish;
    end
endmodule
