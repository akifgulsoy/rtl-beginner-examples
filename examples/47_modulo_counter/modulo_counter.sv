module modulo_counter #(
    parameter int WIDTH = 4,
    parameter logic [WIDTH-1:0] MAX_VALUE = {WIDTH{1'b1}}
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             enable,
    output logic [WIDTH-1:0] count
);
    // Count from zero through MAX_VALUE, then wrap back to zero.
    always_ff @(posedge clk) begin
        if (reset) begin
            count <= '0;
        end else if (enable) begin
            if (count == MAX_VALUE)
                count <= '0;
            else
                count <= count + 1'b1;
        end
    end
endmodule
