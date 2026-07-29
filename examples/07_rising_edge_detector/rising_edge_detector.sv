module rising_edge_detector (
    input  logic clk,
    input  logic rst,
    input  logic signal_in,
    output logic rising_edge
);
    logic signal_in_delayed;

    always_ff @(posedge clk) begin
        if (rst) begin
            signal_in_delayed <= 1'b0;
            rising_edge <= 1'b0;
        end else begin
            signal_in_delayed <= signal_in;
            // A pulse is high for one clock when the sampled input changes from 0 to 1.
            rising_edge <= signal_in & ~signal_in_delayed;
        end
    end
endmodule
