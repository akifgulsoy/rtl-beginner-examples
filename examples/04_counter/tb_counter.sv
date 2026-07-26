`timescale 1ns/1ps

module tb_counter;
    localparam int WIDTH = 4;

    logic             clk = 1'b0;
    logic             rst;
    logic             enable;
    logic [WIDTH-1:0] count;

    counter #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .count(count)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        enable = 1'b0;
        @(posedge clk);
        #1;
        if (count !== '0) $fatal(1, "Synchronous reset failed");

        @(negedge clk);
        rst = 1'b0;
        enable = 1'b1;

        repeat (5) @(posedge clk);
        #1;
        if (count !== 4'd5) $fatal(1, "Expected count=5, got %0d", count);

        @(negedge clk);
        enable = 1'b0;
        repeat (2) @(posedge clk);
        #1;
        if (count !== 4'd5) $fatal(1, "Counter changed while disabled");

        $display("PASS: counter");
        $finish;
    end
endmodule

