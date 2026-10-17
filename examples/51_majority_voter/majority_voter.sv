module majority_voter #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [WIDTH-1:0] c,
    output logic [WIDTH-1:0] vote
);
    // Each output bit is set when at least two corresponding inputs are set.
    assign vote = (a & b) | (a & c) | (b & c);
endmodule
