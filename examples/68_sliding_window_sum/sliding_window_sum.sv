module sliding_window_sum #(
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
    localparam int INDEX_WIDTH = (WINDOW_SIZE > 1) ? $clog2(WINDOW_SIZE) : 1;
    localparam logic [INDEX_WIDTH-1:0] LAST_INDEX = INDEX_WIDTH'(WINDOW_SIZE - 1);

    logic [WIDTH-1:0] samples [0:WINDOW_SIZE-1];
    logic [INDEX_WIDTH-1:0] write_index;
    logic full;
    logic [SUM_WIDTH-1:0] outgoing_sample;

    // Every slot is written before full is set, so the buffer needs no reset.
    assign outgoing_sample = full ? SUM_WIDTH'(samples[write_index]) : '0;

    always_ff @(posedge clk) begin
        if (reset) begin
            write_index <= '0;
            full        <= 1'b0;
            sum         <= '0;
            valid       <= 1'b0;
        end else begin
            valid <= 1'b0;
            if (enable) begin
                // The write slot holds the oldest sample once the buffer fills.
                samples[write_index] <= sample;
                sum   <= sum - outgoing_sample + SUM_WIDTH'(sample);
                valid <= full || (write_index == LAST_INDEX);

                if (write_index == LAST_INDEX) begin
                    write_index <= '0;
                    full        <= 1'b1;
                end else begin
                    write_index <= write_index + 1'b1;
                end
            end
        end
    end
endmodule
