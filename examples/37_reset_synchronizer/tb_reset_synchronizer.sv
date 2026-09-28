`timescale 1ns/1ps

module tb_reset_synchronizer;
    logic clk = 1'b0;
    logic async_reset_n;
    logic reset_n;

    reset_synchronizer #(.STAGES(2)) dut (
        .clk(clk),
        .async_reset_n(async_reset_n),
        .reset_n(reset_n)
    );

    always #5 clk = ~clk;

    initial begin
        async_reset_n = 1'b0;
        #2;
        if (reset_n !== 1'b0)
            $fatal(1, "reset must assert immediately");

        // Release between edges: reset remains active for two clock edges.
        #5;
        async_reset_n = 1'b1;
        if (reset_n !== 1'b0)
            $fatal(1, "reset released before a clock edge");

        @(posedge clk);
        #1;
        if (reset_n !== 1'b0)
            $fatal(1, "reset released after only one clock edge");

        @(posedge clk);
        #1;
        if (reset_n !== 1'b1)
            $fatal(1, "reset did not release after two clock edges");

        // A later assertion is asynchronous even while the clock is low.
        @(negedge clk);
        #2;
        async_reset_n = 1'b0;
        #1;
        if (reset_n !== 1'b0)
            $fatal(1, "later reset assertion was not immediate");

        $display("PASS: reset synchronizer");
        $finish;
    end
endmodule
