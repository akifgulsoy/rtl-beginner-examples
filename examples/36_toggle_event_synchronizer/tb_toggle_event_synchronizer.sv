`timescale 1ns/1ps

module tb_toggle_event_synchronizer;
    logic src_clk = 1'b0;
    logic dst_clk = 1'b0;
    logic src_reset;
    logic dst_reset;
    logic src_pulse;
    logic dst_pulse;
    int pulse_count;

    toggle_event_synchronizer dut (
        .src_clk(src_clk),
        .src_reset(src_reset),
        .src_pulse(src_pulse),
        .dst_clk(dst_clk),
        .dst_reset(dst_reset),
        .dst_pulse(dst_pulse)
    );

    always #4 src_clk = ~src_clk;
    always #7 dst_clk = ~dst_clk;

    task automatic send_source_event;
        @(negedge src_clk);
        src_pulse = 1'b1;
        @(negedge src_clk);
        src_pulse = 1'b0;
    endtask

    task automatic expect_one_destination_pulse;
        pulse_count = 0;
        repeat (6) begin
            @(posedge dst_clk);
            #1;
            if (dst_pulse === 1'b1)
                pulse_count++;
            else if (dst_pulse !== 1'b0)
                $fatal(1, "dst_pulse is unknown");
        end
        if (pulse_count != 1)
            $fatal(1, "expected one destination pulse, got %0d", pulse_count);
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

        // No event is generated merely by releasing reset.
        repeat (3) begin
            @(posedge dst_clk);
            #1;
            if (dst_pulse !== 1'b0)
                $fatal(1, "unexpected destination pulse after reset");
        end

        // A one-source-cycle event becomes exactly one destination-clock pulse.
        send_source_event();
        expect_one_destination_pulse();

        // A later event toggles in the other direction and is detected as well.
        send_source_event();
        expect_one_destination_pulse();

        $display("PASS: toggle event synchronizer");
        $finish;
    end
endmodule
