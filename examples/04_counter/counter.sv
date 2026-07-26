module counter #(
    parameter int WIDTH = 4
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             enable,
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk) begin
        if (rst)
            count <= '0;
        else if (enable)
            count <= count + 1'b1;
    end
endmodule

