`timescale 1ns/1ps

module tb_d_flip_flop;
    logic clk = 1'b0;
    logic rst_n;
    logic d;
    logic q;

    d_flip_flop dut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0;
        d = 1'b0;
        #1;
        if (q !== 1'b0) $fatal(1, "Asynchronous reset failed");

        @(negedge clk);
        rst_n = 1'b1;
        d = 1'b1;
        @(posedge clk);
        #1;
        if (q !== 1'b1) $fatal(1, "Flip-flop did not capture 1");

        @(negedge clk);
        d = 1'b0;
        @(posedge clk);
        #1;
        if (q !== 1'b0) $fatal(1, "Flip-flop did not capture 0");

        rst_n = 1'b0;
        #1;
        if (q !== 1'b0) $fatal(1, "Asynchronous reset did not clear q");

        $display("PASS: d_flip_flop");
        $finish;
    end
endmodule

