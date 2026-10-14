module pulse_width_measurement #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             signal_in,
    output logic [WIDTH-1:0] pulse_width,
    output logic             width_valid
);
    logic [WIDTH-1:0] high_count;
    logic             measuring;

    // Count each sampled high cycle. When the input returns low, capture the
    // completed width and mark it valid for one clock cycle.
    always_ff @(posedge clk) begin
        if (reset) begin
            high_count  <= '0;
            measuring   <= 1'b0;
            pulse_width <= '0;
            width_valid <= 1'b0;
        end else begin
            width_valid <= 1'b0;

            if (!measuring) begin
                if (signal_in) begin
                    high_count <= {{(WIDTH-1){1'b0}}, 1'b1};
                    measuring  <= 1'b1;
                end
            end else if (signal_in) begin
                high_count <= high_count + 1'b1;
            end else begin
                pulse_width <= high_count;
                width_valid <= 1'b1;
                high_count  <= '0;
                measuring   <= 1'b0;
            end
        end
    end
endmodule
