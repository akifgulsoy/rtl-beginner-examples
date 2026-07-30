`timescale 1ns/1ps

module tb_two_flip_flop_synchronizer;
    logic clk = 1'b0;
    logic rst;
    logic async_in;
    logic sync_out;

    two_flip_flop_synchronizer dut (
        .clk(clk),
        .rst(rst),
        .async_in(async_in),
        .sync_out(sync_out)
    );

    always #5 clk = ~clk;

    task automatic check_output(input logic expected);
        #1;
        if (sync_out !== expected)
            $fatal(1, "Expected sync_out=%b, got %b", expected, sync_out);
    endtask

    initial begin
        rst = 1'b1;
        async_in = 1'b0;
        @(posedge clk);
        check_output(1'b0);

        @(negedge clk);
        rst = 1'b0;
        async_in = 1'b1;

        // The first stage samples the input, while the output keeps its old value.
        @(posedge clk);
        check_output(1'b0);
        // The second stage makes the sampled value available one clock later.
        @(posedge clk);
        check_output(1'b1);

        @(negedge clk);
        async_in = 1'b0;
        @(posedge clk);
        check_output(1'b1);
        @(posedge clk);
        check_output(1'b0);

        $display("PASS: two_flip_flop_synchronizer");
        $finish;
    end
endmodule
