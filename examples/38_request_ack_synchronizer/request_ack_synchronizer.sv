module request_ack_synchronizer (
    input  logic src_clk,
    input  logic src_reset,
    input  logic src_pulse,
    output logic src_busy,
    input  logic dst_clk,
    input  logic dst_reset,
    output logic dst_pulse
);
    logic request_toggle;
    logic ack_toggle;
    logic request_sync1;
    logic request_sync2;
    logic request_seen;
    logic ack_sync1;
    logic ack_sync2;

    // The source accepts a new event only after the previous acknowledgement
    // has returned through the synchronizer.
    always_ff @(posedge src_clk) begin
        if (src_reset) begin
            request_toggle <= 1'b0;
            ack_sync1      <= 1'b0;
            ack_sync2      <= 1'b0;
        end else begin
            ack_sync1 <= ack_toggle;
            ack_sync2 <= ack_sync1;
            if (src_pulse && !src_busy)
                request_toggle <= ~request_toggle;
        end
    end

    assign src_busy = request_toggle != ack_sync2;

    // The destination turns each synchronized request toggle into one pulse,
    // then mirrors the toggle back as an acknowledgement.
    always_ff @(posedge dst_clk) begin
        if (dst_reset) begin
            request_sync1 <= 1'b0;
            request_sync2 <= 1'b0;
            request_seen  <= 1'b0;
            ack_toggle    <= 1'b0;
            dst_pulse     <= 1'b0;
        end else begin
            request_sync1 <= request_toggle;
            request_sync2 <= request_sync1;
            dst_pulse     <= request_sync2 ^ request_seen;
            if (request_sync2 != request_seen) begin
                request_seen <= request_sync2;
                ack_toggle   <= request_sync2;
            end
        end
    end
endmodule
