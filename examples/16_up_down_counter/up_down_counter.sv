module up_down_counter #(
    parameter int WIDTH = 4
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             enable,
    input  logic             up,
    output logic [WIDTH-1:0] count
);
    // Unsigned arithmetic naturally wraps at the counter limits.
    always_ff @(posedge clk) begin
        if (reset)
            count <= '0;
        else if (enable) begin
            if (up)
                count <= count + 1'b1;
            else
                count <= count - 1'b1;
        end
    end
endmodule
