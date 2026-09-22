module parallel_to_serial #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             load,
    input  logic             shift_enable,
    input  logic [WIDTH-1:0] parallel_data,
    output logic             serial_out
);
    logic [WIDTH-1:0] shift_reg;

    // The least-significant bit is presented first.
    assign serial_out = shift_reg[0];

    always_ff @(posedge clk) begin
        if (reset)
            shift_reg <= '0;
        else if (load)
            shift_reg <= parallel_data;
        else if (shift_enable)
            shift_reg <= {1'b0, shift_reg[WIDTH-1:1]};
    end
endmodule
