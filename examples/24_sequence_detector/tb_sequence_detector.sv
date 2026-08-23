`timescale 1ns/1ps

module tb_sequence_detector;
    logic clk = 1'b0;
    logic rst_n;
    logic bit_in;
    logic detected;

    sequence_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .bit_in(bit_in),
        .detected(detected)
    );

    always #5 clk = ~clk;

    task automatic send_bit(
        input logic input_bit,
        input logic expected_detected
    );
        @(negedge clk);
        bit_in = input_bit;
        @(posedge clk);
        #1;

        if (detected !== expected_detected)
            $fatal(1, "bit_in=%b: expected detected=%b, got %b",
                   input_bit, expected_detected, detected);
    endtask

    initial begin
        rst_n = 1'b0;
        bit_in = 1'b0;
        #1;
        if (detected !== 1'b0)
            $fatal(1, "detected must be low during reset");

        @(negedge clk);
        rst_n = 1'b1;

        // A partial match interrupted by 0 must not be reported.
        send_bit(1'b1, 1'b0);
        send_bit(1'b0, 1'b0);
        send_bit(1'b0, 1'b0);

        // Detect 1011, then detect the overlapping 1011 in 1011011.
        send_bit(1'b1, 1'b0);
        send_bit(1'b0, 1'b0);
        send_bit(1'b1, 1'b0);
        send_bit(1'b1, 1'b1);
        send_bit(1'b0, 1'b0);
        send_bit(1'b1, 1'b0);
        send_bit(1'b1, 1'b1);

        $display("PASS: sequence_detector");
        $finish;
    end
endmodule
