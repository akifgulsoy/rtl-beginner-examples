`timescale 1ns/1ps

module tb_one_shot_timer;
    logic clk = 1'b0;
    logic reset;
    logic start;
    logic [2:0] delay_cycles;
    logic active;
    logic done;

    one_shot_timer #(.WIDTH(3)) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .delay_cycles(delay_cycles),
        .active(active),
        .done(done)
    );

    always #5 clk = ~clk;

    task automatic expect_state(
        input logic expected_active,
        input logic expected_done,
        input string label
    );
        #1;
        if (active !== expected_active || done !== expected_done)
            $fatal(1, "%s: expected active=%b done=%b, got active=%b done=%b",
                   label, expected_active, expected_done, active, done);
    endtask

    initial begin
        reset = 1'b1;
        start = 1'b0;
        delay_cycles = '0;
        @(posedge clk);
        expect_state(1'b0, 1'b0, "reset");

        @(negedge clk);
        reset = 1'b0;
        delay_cycles = 3'd3;
        start = 1'b1;
        @(posedge clk);
        expect_state(1'b1, 1'b0, "timer start");

        // A second start while active must not restart or change the delay.
        @(negedge clk);
        delay_cycles = 3'd1;
        start = 1'b1;
        @(posedge clk);
        expect_state(1'b1, 1'b0, "first countdown cycle");
        @(negedge clk);
        start = 1'b0;
        @(posedge clk);
        expect_state(1'b1, 1'b0, "second countdown cycle");
        @(posedge clk);
        expect_state(1'b0, 1'b1, "completion after three cycles");
        @(posedge clk);
        expect_state(1'b0, 1'b0, "one-clock done pulse");

        // A zero delay generates done without making the timer active.
        @(negedge clk);
        delay_cycles = '0;
        start = 1'b1;
        @(posedge clk);
        expect_state(1'b0, 1'b1, "zero-delay completion");
        @(negedge clk);
        start = 1'b0;
        @(posedge clk);
        expect_state(1'b0, 1'b0, "zero-delay done clears");

        $display("PASS: one_shot_timer");
        $finish;
    end
endmodule
