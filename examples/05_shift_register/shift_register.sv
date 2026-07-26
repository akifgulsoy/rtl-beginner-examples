module shift_register #(
    parameter int WIDTH = 4
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             enable,
    input  logic             serial_in,
    output logic [WIDTH-1:0] parallel_out
);
    always_ff @(posedge clk) begin
        if (rst)
            parallel_out <= '0;
        else if (enable)
            parallel_out <= {parallel_out[WIDTH-2:0], serial_in};
    end
endmodule

