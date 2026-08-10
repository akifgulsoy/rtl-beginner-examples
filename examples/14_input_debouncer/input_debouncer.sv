module input_debouncer #(
    parameter int SAMPLE_CYCLES = 3
) (
    input  logic clk,
    input  logic reset,
    input  logic noisy_in,
    output logic clean_out
);
    localparam int COUNTER_WIDTH = (SAMPLE_CYCLES <= 1) ? 1 : $clog2(SAMPLE_CYCLES);

    logic [COUNTER_WIDTH-1:0] stable_count;

    // Accept a new input level only after it has stayed different long enough.
    always_ff @(posedge clk) begin
        if (reset) begin
            clean_out    <= 1'b0;
            stable_count <= '0;
        end else if (noisy_in == clean_out) begin
            stable_count <= '0;
        end else if (stable_count == SAMPLE_CYCLES - 1) begin
            clean_out    <= noisy_in;
            stable_count <= '0;
        end else begin
            stable_count <= stable_count + 1'b1;
        end
    end
endmodule
