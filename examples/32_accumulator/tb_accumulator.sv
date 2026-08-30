`timescale 1ns/1ps

module tb_accumulator;
    logic clk = 1'b0;
    logic reset;
    logic enable;
    logic clear;
    logic [3:0] data_in;
    logic [3:0] sum;

    accumulator #(.WIDTH(4)) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .clear(clear),
        .data_in(data_in),
        .sum(sum)
    );

    always #5 clk = ~clk;

    task check_sum(input logic [3:0] expected_sum);
        if (sum !== expected_sum)
            $fatal(1, "expected sum %0d, got %0d", expected_sum, sum);
    endtask

    initial begin
        reset = 1'b1;
        enable = 1'b0;
        clear = 1'b0;
        data_in = '0;

        @(posedge clk);
        #1;
        check_sum(4'd0);

        reset = 1'b0;
        enable = 1'b1;
        data_in = 4'd3;
        @(posedge clk);
        #1;
        check_sum(4'd3);

        data_in = 4'd5;
        @(posedge clk);
        #1;
        check_sum(4'd8);

        // A disabled accumulator holds its previous running total.
        enable = 1'b0;
        data_in = 4'd7;
        @(posedge clk);
        #1;
        check_sum(4'd8);

        // Clear takes precedence over an enabled addition.
        enable = 1'b1;
        clear = 1'b1;
        data_in = 4'd4;
        @(posedge clk);
        #1;
        check_sum(4'd0);

        clear = 1'b0;
        data_in = 4'd15;
        @(posedge clk);
        #1;
        check_sum(4'd15);

        // Arithmetic wraps naturally at the configured output width.
        data_in = 4'd2;
        @(posedge clk);
        #1;
        check_sum(4'd1);

        $display("PASS: accumulator");
        $finish;
    end
endmodule
