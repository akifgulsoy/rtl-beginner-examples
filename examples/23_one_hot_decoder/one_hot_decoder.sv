module one_hot_decoder #(
    parameter int INDEX_WIDTH = 3
) (
    input  logic [INDEX_WIDTH-1:0] index,
    input  logic                   enable,
    output logic [(1 << INDEX_WIDTH)-1:0] decoded
);
    // With enable asserted, exactly the bit selected by index is high.
    always_comb begin
        decoded = '0;

        if (enable)
            decoded[index] = 1'b1;
    end
endmodule
