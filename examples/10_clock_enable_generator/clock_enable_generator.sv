module clock_enable_generator #(
    parameter int DIVIDE_BY = 4
) (
    input  logic clk,
    input  logic rst,
    output logic clock_enable
);
    localparam int COUNT_WIDTH = (DIVIDE_BY <= 1) ? 1 : $clog2(DIVIDE_BY);

    logic [COUNT_WIDTH-1:0] count;

    // Generate one enable pulse every DIVIDE_BY input clock cycles.
    always_ff @(posedge clk) begin
        if (rst) begin
            count        <= '0;
            clock_enable <= 1'b0;
        end else if (count == DIVIDE_BY - 1) begin
            count        <= '0;
            clock_enable <= 1'b1;
        end else begin
            count        <= count + 1'b1;
            clock_enable <= 1'b0;
        end
    end
endmodule
