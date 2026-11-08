module min_max_tracker #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             enable,
    input  logic [WIDTH-1:0] sample,
    output logic             valid,
    output logic [WIDTH-1:0] minimum,
    output logic [WIDTH-1:0] maximum
);
    // Track unsigned samples accepted on enabled rising clock edges.
    always_ff @(posedge clk) begin
        if (reset) begin
            valid   <= 1'b0;
            minimum <= '0;
            maximum <= '0;
        end else if (enable) begin
            // The first sample seeds both limits, so reset zeros do not bias them.
            if (!valid) begin
                minimum <= sample;
                maximum <= sample;
            end else begin
                if (sample < minimum)
                    minimum <= sample;
                if (sample > maximum)
                    maximum <= sample;
            end
            valid <= 1'b1;
        end
    end
endmodule
