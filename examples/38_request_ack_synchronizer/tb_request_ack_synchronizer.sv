`timescale 1ns/1ps

module tb_request_ack_synchronizer;
    logic src_clk = 1'b0;
    logic dst_clk = 1'b0;
    logic src_reset;
    logic dst_reset;
    logic src_pulse;
    logic src_busy;
    logic dst_pulse;
    int destination_pulses;

    request_ack_synchronizer dut (
        .src_clk(src_clk),
        .src_reset(src_reset),
        .src_pulse(src_pulse),
        .src_busy(src_busy),
        .dst_clk(dst_clk),
        .dst_reset(dst_reset),
        .dst_pulse(dst_pulse)
    );

    always #4 src_clk = ~src_clk;
    always #7 dst_clk = ~dst_clk;

    task automatic pulse_source;
        begin
            @(negedge src_clk);
            src_pulse = 1'b1;
            @(negedge src_clk);
            src_pulse = 1'b0;
        end
    endtask

    task automatic expect_one_pulse_and_idle;
        int observed;
        begin
            observed = 0;
            repeat (8) begin
                @(posedge dst_clk);
                #1;
                if (dst_pulse === 1'b1)
                    observed++;
                else if (dst_pulse !== 1'b0)
                    $fatal(1, "dst_pulse is unknown");
            end
            if (observed != 1)
                $fatal(1, "expected one destination pulse, got %0d", observed);
            if (src_busy !== 1'b0)
                $fatal(1, "source stayed busy after acknowledgement");
        end
    endtask

    initial begin
        src_reset = 1'b1;
        dst_reset = 1'b1;
        src_pulse = 1'b0;

        repeat (2) @(posedge src_clk);
        @(negedge src_clk);
        src_reset = 1'b0;
        @(negedge dst_clk);
        dst_reset = 1'b0;

        if (src_busy !== 1'b0)
            $fatal(1, "source is unexpectedly busy after reset");

        // The first request is accepted, then blocks a second request while
        // its acknowledgement is still travelling back to the source.
        pulse_source();
        #1;
        if (src_busy !== 1'b1)
            $fatal(1, "source did not become busy after a request");
        pulse_source();
        expect_one_pulse_and_idle();

        // Once idle, the opposite toggle direction carries another request.
        pulse_source();
        #1;
        if (src_busy !== 1'b1)
            $fatal(1, "source did not become busy for the second request");
        expect_one_pulse_and_idle();

        $display("PASS: request acknowledgement synchronizer");
        $finish;
    end
endmodule
