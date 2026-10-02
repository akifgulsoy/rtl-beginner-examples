module lfsr (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       enable,
    output logic [3:0] value
);
    // x^4 + x^3 + 1 is a maximal-length polynomial for four bits.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            value <= 4'b0001;
        else if (enable)
            value <= {value[2:0], value[3] ^ value[2]};
    end
endmodule
