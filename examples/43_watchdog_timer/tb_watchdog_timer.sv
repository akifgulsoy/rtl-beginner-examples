`timescale 1ns/1ps

module tb_watchdog_timer;
    localparam int CYCLES = 3;

    logic clk = 1'b0;
    logic rst;
    logic kick;
    logic timeout;

    watchdog_timer #(.CYCLES(CYCLES)) dut (
        .clk(clk),
        .rst(rst),
        .kick(kick),
        .timeout(timeout)
    );

    always #5 clk = ~clk;

    task automatic check_timeout(input logic expected, input string label);
        if (timeout !== expected)
            $fatal(1, "%s: expected timeout=%b, got %b", label, expected, timeout);
    endtask

    initial begin
        rst  = 1'b1;
        kick = 1'b0;
        @(posedge clk);
        #1;
        check_timeout(1'b0, "reset clears timeout");

        rst = 1'b0;
        // A kick before expiration restarts the full interval.
        repeat (2) begin
            @(posedge clk);
            #1;
            check_timeout(1'b0, "watchdog has not expired");
        end
        kick = 1'b1;
        @(posedge clk);
        #1;
        check_timeout(1'b0, "kick clears timeout");
        kick = 1'b0;

        // With no more kicks, timeout asserts on the third idle clock edge.
        repeat (CYCLES - 1) begin
            @(posedge clk);
            #1;
            check_timeout(1'b0, "timeout waits for full interval");
        end
        @(posedge clk);
        #1;
        check_timeout(1'b1, "timeout asserts after interval");

        // The expired state persists until a service event arrives.
        @(posedge clk);
        #1;
        check_timeout(1'b1, "timeout remains asserted");
        kick = 1'b1;
        @(posedge clk);
        #1;
        check_timeout(1'b0, "kick recovers watchdog");

        $display("PASS: watchdog_timer");
        $finish;
    end
endmodule
