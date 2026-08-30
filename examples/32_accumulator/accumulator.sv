module accumulator #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             enable,
    input  logic             clear,
    input  logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] sum
);
    always_ff @(posedge clk) begin
        if (reset)
            sum <= '0;
        else if (clear)
            sum <= '0;
        else if (enable)
            sum <= sum + data_in;
    end
endmodule
