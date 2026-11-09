module windowed_sum #(
    parameter int WIDTH = 8,
    parameter int WINDOW_SIZE = 4,
    localparam int SUM_WIDTH = WIDTH + $clog2(WINDOW_SIZE)
) (
    input  logic                 clk,
    input  logic                 reset,
    input  logic                 enable,
    input  logic [WIDTH-1:0]     sample,
    output logic [SUM_WIDTH-1:0] sum,
    output logic                 valid
);
    localparam int COUNT_WIDTH = (WINDOW_SIZE > 1) ? $clog2(WINDOW_SIZE) : 1;
    localparam logic [COUNT_WIDTH-1:0] LAST_SAMPLE = COUNT_WIDTH'(WINDOW_SIZE - 1);

    logic [COUNT_WIDTH-1:0] sample_count;
    logic [SUM_WIDTH-1:0] partial_sum, next_sum;

    assign next_sum = partial_sum + SUM_WIDTH'(sample);

    always_ff @(posedge clk) begin
        if (reset) begin
            sample_count <= '0;
            partial_sum  <= '0;
            sum          <= '0;
            valid        <= 1'b0;
        end else begin
            valid <= 1'b0;
            if (enable) begin
                if (sample_count == LAST_SAMPLE) begin
                    // Publish the sum including this sample and start a fresh window.
                    sum          <= next_sum;
                    valid        <= 1'b1;
                    sample_count <= '0;
                    partial_sum  <= '0;
                end else begin
                    sample_count <= sample_count + 1'b1;
                    partial_sum  <= next_sum;
                end
            end
        end
    end
endmodule
