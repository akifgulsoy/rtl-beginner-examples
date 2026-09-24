module valid_ready_register #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             in_valid,
    output logic             in_ready,
    input  logic [WIDTH-1:0] in_data,
    output logic             out_valid,
    input  logic             out_ready,
    output logic [WIDTH-1:0] out_data
);
    // The input can transfer when the register is empty or its word is consumed.
    assign in_ready = !out_valid || out_ready;

    always_ff @(posedge clk) begin
        if (reset) begin
            out_valid <= 1'b0;
            out_data  <= '0;
        end else if (in_ready) begin
            // A simultaneous output transfer can be replaced with a new input word.
            out_valid <= in_valid;
            if (in_valid)
                out_data <= in_data;
        end
    end
endmodule
