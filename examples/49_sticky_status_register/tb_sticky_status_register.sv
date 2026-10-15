`timescale 1ns/1ps

module tb_sticky_status_register;
    logic clk = 1'b0;
    logic reset;
    logic [3:0] event_set;
    logic [3:0] clear_mask;
    logic [3:0] status;

    sticky_status_register #(.WIDTH(4)) dut (
        .clk(clk),
        .reset(reset),
        .event_set(event_set),
        .clear_mask(clear_mask),
        .status(status)
    );

    always #5 clk = ~clk;

    task automatic expect_status(input logic [3:0] expected, input string label);
        #1;
        if (status !== expected)
            $fatal(1, "%s: expected status=%b, got %b", label, expected, status);
    endtask

    initial begin
        reset      = 1'b1;
        event_set  = '0;
        clear_mask = '0;
        @(posedge clk);
        expect_status(4'b0000, "reset clears every status bit");

        @(negedge clk);
        reset     = 1'b0;
        event_set = 4'b0101;
        @(posedge clk);
        expect_status(4'b0101, "events set their matching bits");

        @(negedge clk);
        event_set = 4'b0011;
        @(posedge clk);
        expect_status(4'b0111, "previous events remain sticky");

        @(negedge clk);
        event_set  = '0;
        clear_mask = 4'b0100;
        @(posedge clk);
        expect_status(4'b0011, "clear mask removes only selected bits");

        @(negedge clk);
        event_set  = 4'b0100;
        clear_mask = 4'b0100;
        @(posedge clk);
        expect_status(4'b0111, "same-cycle event takes priority over clear");

        @(negedge clk);
        event_set  = '0;
        clear_mask = 4'b1111;
        @(posedge clk);
        expect_status(4'b0000, "all bits can be cleared together");

        $display("PASS: sticky_status_register");
        $finish;
    end
endmodule
