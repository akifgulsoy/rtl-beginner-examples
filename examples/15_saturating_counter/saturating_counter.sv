module saturating_counter #(
    parameter int WIDTH = 4
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             enable,
    input  logic             up,
    output logic [WIDTH-1:0] count
);
    localparam logic [WIDTH-1:0] MAX_COUNT = {WIDTH{1'b1}};

    // Hold at either limit instead of wrapping around.
    always_ff @(posedge clk) begin
        if (reset) begin
            count <= '0;
        end else if (enable) begin
            if (up && count != MAX_COUNT)
                count <= count + 1'b1;
            else if (!up && count != '0)
                count <= count - 1'b1;
        end
    end
endmodule
