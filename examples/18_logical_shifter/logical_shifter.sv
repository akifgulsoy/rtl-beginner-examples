module logical_shifter #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] data_in,
    input  logic [$clog2(WIDTH):0] shift_amount,
    input  logic             shift_right,
    output logic [WIDTH-1:0] data_out
);
    // Logical shifts fill the vacated bit positions with zeros.
    always_comb begin
        if (shift_right)
            data_out = data_in >> shift_amount;
        else
            data_out = data_in << shift_amount;
    end
endmodule
