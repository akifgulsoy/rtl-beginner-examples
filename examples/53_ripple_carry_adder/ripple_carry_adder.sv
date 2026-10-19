module ripple_carry_adder #(
    parameter int WIDTH = 4 // WIDTH must be at least 1.
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             carry_in,
    output logic [WIDTH-1:0] sum,
    output logic             carry_out
);
    logic [WIDTH:0] carry;

    assign carry[0] = carry_in;
    assign carry_out = carry[WIDTH];

    // Each full adder passes its carry to the next more significant bit.
    for (genvar i = 0; i < WIDTH; i = i + 1) begin : bit_adder
        assign sum[i] = a[i] ^ b[i] ^ carry[i];
        assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) |
                            (b[i] & carry[i]);
    end
endmodule
