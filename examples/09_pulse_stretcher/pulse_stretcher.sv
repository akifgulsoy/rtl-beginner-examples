module pulse_stretcher #(
    parameter int STRETCH_CYCLES = 3
) (
    input  logic clk,
    input  logic rst,
    input  logic pulse_in,
    output logic pulse_out
);
    localparam int COUNT_WIDTH = $clog2(STRETCH_CYCLES);

    logic [COUNT_WIDTH-1:0] cycles_left;

    // A new input pulse starts the timer only while the output is idle.
    always_ff @(posedge clk) begin
        if (rst) begin
            cycles_left <= '0;
            pulse_out   <= 1'b0;
        end else if (!pulse_out && pulse_in) begin
            cycles_left <= STRETCH_CYCLES - 1;
            pulse_out   <= 1'b1;
        end else if (pulse_out && cycles_left != '0) begin
            cycles_left <= cycles_left - 1'b1;
        end else begin
            pulse_out <= 1'b0;
        end
    end
endmodule
