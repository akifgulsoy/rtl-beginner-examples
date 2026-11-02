module write_mask_register #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             write_en,
    input  logic [WIDTH-1:0] write_data,
    input  logic [WIDTH-1:0] write_mask,
    output logic [WIDTH-1:0] value
);
    // A one in write_mask updates that bit; a zero preserves its old value.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            value <= '0;
        else if (write_en)
            value <= (value & ~write_mask) | (write_data & write_mask);
    end
endmodule
