module bit_rotator #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] data_in,
    input  logic [$clog2(WIDTH):0] rotate_amount,
    input  logic             rotate_right,
    output logic [WIDTH-1:0] data_out
);
    int unsigned amount;

    // A rotation returns bits at one end to the other end instead of filling
    // the vacated positions with zeros.
    always_comb begin
        amount = rotate_amount % WIDTH;

        if (rotate_right)
            data_out = (data_in >> amount) | (data_in << (WIDTH - amount));
        else
            data_out = (data_in << amount) | (data_in >> (WIDTH - amount));
    end
endmodule
