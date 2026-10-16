module hysteresis_comparator #(
    parameter int WIDTH = 8,
    parameter logic [WIDTH-1:0] ASSERT_LEVEL = 8'd192,
    parameter logic [WIDTH-1:0] DEASSERT_LEVEL = 8'd160
) (
    input  logic             clk,
    input  logic             reset,
    input  logic [WIDTH-1:0] sample,
    output logic             alert
);
    // Separate thresholds prevent alert from toggling when the sample moves
    // back and forth near one boundary. The old alert state selects which
    // threshold applies on each clock edge.
    always_ff @(posedge clk) begin
        if (reset)
            alert <= 1'b0;
        else if (!alert && sample >= ASSERT_LEVEL)
            alert <= 1'b1;
        else if (alert && sample <= DEASSERT_LEVEL)
            alert <= 1'b0;
    end
endmodule
