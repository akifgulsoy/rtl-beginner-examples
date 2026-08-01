`timescale 1ns/1ps

module tb_clock_enable_generator;
    logic clk = 1'b0;
    logic rst;
    logic clock_enable;

    clock_enable_generator #(.DIVIDE_BY(4)) dut (
        .clk(clk),
        .rst(rst),
        .clock_enable(clock_enable)
    );

    always #5 clk = ~clk;

    task automatic check_enable(input logic expected);
        #1;
        if (clock_enable !== expected)
            $fatal(1, "Expected clock_enable=%b, got %b", expected, clock_enable);
    endtask

    initial begin
        rst = 1'b1;
        @(posedge clk);
        check_enable(1'b0);

        @(negedge clk);
        rst = 1'b0;

        // The enable is low for three cycles and high on the fourth.
        repeat (3) begin
            @(posedge clk);
            check_enable(1'b0);
        end
        @(posedge clk);
        check_enable(1'b1);

        // The counter restarts, producing the same four-cycle pattern.
        repeat (3) begin
            @(posedge clk);
            check_enable(1'b0);
        end
        @(posedge clk);
        check_enable(1'b1);

        $display("PASS: clock_enable_generator");
        $finish;
    end
endmodule
