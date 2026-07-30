module two_flip_flop_synchronizer (
    input  logic clk,
    input  logic rst,
    input  logic async_in,
    output logic sync_out
);
    logic first_stage;

    // The second stage is the signal used by logic in the clk domain.
    always_ff @(posedge clk) begin
        if (rst) begin
            first_stage <= 1'b0;
            sync_out    <= 1'b0;
        end else begin
            first_stage <= async_in;
            sync_out    <= first_stage;
        end
    end
endmodule
