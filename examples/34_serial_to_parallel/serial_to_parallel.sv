module serial_to_parallel #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             shift_enable,
    input  logic             serial_in,
    output logic [WIDTH-1:0] parallel_data
);
    always_ff @(posedge clk) begin
        if (reset)
            parallel_data <= '0;
        else if (shift_enable)
            // The first serial bit becomes bit 0 after WIDTH shifts.
            parallel_data <= {serial_in, parallel_data[WIDTH-1:1]};
    end
endmodule
