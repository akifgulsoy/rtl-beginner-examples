module toggle_event_synchronizer (
    input  logic src_clk,
    input  logic src_reset,
    input  logic src_pulse,
    input  logic dst_clk,
    input  logic dst_reset,
    output logic dst_pulse
);
    logic src_toggle;
    logic sync_stage1;
    logic sync_stage2;
    logic sync_stage2_delayed;

    // Each source event changes state, so a short source pulse cannot be missed.
    always_ff @(posedge src_clk) begin
        if (src_reset)
            src_toggle <= 1'b0;
        else if (src_pulse)
            src_toggle <= ~src_toggle;
    end

    // The destination samples the toggle through two flip-flops, then detects it.
    always_ff @(posedge dst_clk) begin
        if (dst_reset) begin
            sync_stage1         <= 1'b0;
            sync_stage2         <= 1'b0;
            sync_stage2_delayed <= 1'b0;
            dst_pulse           <= 1'b0;
        end else begin
            sync_stage1         <= src_toggle;
            sync_stage2         <= sync_stage1;
            sync_stage2_delayed <= sync_stage2;
            dst_pulse           <= sync_stage2 ^ sync_stage2_delayed;
        end
    end
endmodule
