module clock_divider #(
    parameter int HALF_PERIOD = 2
) (
    input  logic clk,
    input  logic rst,
    output logic clk_out
);
    localparam int COUNT_WIDTH = (HALF_PERIOD <= 1) ? 1 : $clog2(HALF_PERIOD);

    logic [COUNT_WIDTH-1:0] count;

    always_ff @(posedge clk) begin
        if (rst) begin
            count   <= '0;
            clk_out <= 1'b0;
        end else if (count == HALF_PERIOD - 1) begin
            // Toggle after each half period to form a slower square wave.
            count   <= '0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule
