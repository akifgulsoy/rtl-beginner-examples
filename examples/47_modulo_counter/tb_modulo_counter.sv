`timescale 1ns/1ps

module tb_modulo_counter;
    logic clk = 1'b0;
    logic reset;
    logic enable;
    logic [3:0] count;

    modulo_counter #(
        .WIDTH(4),
        .MAX_VALUE(4'd5)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );

    always #5 clk = ~clk;

    task automatic expect_count(
        input logic [3:0] expected,
        input string label
    );
        #1;
        if (count !== expected)
            $fatal(1, "%s: expected count=%0d, got %0d", label, expected, count);
    endtask

    initial begin
        reset = 1'b1;
        enable = 1'b0;
        @(posedge clk);
        expect_count(4'd0, "reset clears the counter");

        @(negedge clk);
        reset = 1'b0;
        enable = 1'b1;
        @(posedge clk);
        expect_count(4'd1, "first enabled count");
        @(posedge clk);
        expect_count(4'd2, "second enabled count");
        @(posedge clk);
        expect_count(4'd3, "third enabled count");
        @(posedge clk);
        expect_count(4'd4, "fourth enabled count");
        @(posedge clk);
        expect_count(4'd5, "configured maximum count");
        @(posedge clk);
        expect_count(4'd0, "wrap after configured maximum");

        @(negedge clk);
        enable = 1'b0;
        @(posedge clk);
        expect_count(4'd0, "disabled counter holds its value");

        @(negedge clk);
        enable = 1'b1;
        @(posedge clk);
        expect_count(4'd1, "count resumes when enabled");

        @(negedge clk);
        reset = 1'b1;
        @(posedge clk);
        expect_count(4'd0, "reset works while counting");

        $display("PASS: modulo_counter");
        $finish;
    end
endmodule
