module carry_lookahead_adder (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       carry_in,
    output logic [3:0] sum,
    output logic       carry_out
);
    logic [3:0] propagate;
    logic [3:0] generate_bits;
    logic [4:0] carry;

    // A bit propagates an incoming carry when exactly one input is high.
    assign propagate = a ^ b;
    assign generate_bits = a & b;
    assign carry[0] = carry_in;

    // Each carry is expressed directly from the inputs below it.
    assign carry[1] = generate_bits[0] | (propagate[0] & carry[0]);
    assign carry[2] = generate_bits[1] | (propagate[1] & generate_bits[0]) |
                      (propagate[1] & propagate[0] & carry[0]);
    assign carry[3] = generate_bits[2] | (propagate[2] & generate_bits[1]) |
                      (propagate[2] & propagate[1] & generate_bits[0]) |
                      (propagate[2] & propagate[1] & propagate[0] & carry[0]);
    assign carry[4] = generate_bits[3] | (propagate[3] & generate_bits[2]) |
                      (propagate[3] & propagate[2] & generate_bits[1]) |
                      (propagate[3] & propagate[2] & propagate[1] & generate_bits[0]) |
                      (propagate[3] & propagate[2] & propagate[1] &
                       propagate[0] & carry[0]);

    assign sum = propagate ^ carry[3:0];
    assign carry_out = carry[4];
endmodule
