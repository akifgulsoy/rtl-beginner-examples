module unsigned_subtractor #(
    parameter int WIDTH = 8 // WIDTH must be at least 1.
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             borrow_in,
    output logic [WIDTH-1:0] difference,
    output logic             borrow_out
);
    logic [WIDTH:0] extended_difference;

    // Zero-extend before subtracting to preserve an unsigned underflow bit.
    // borrow_in subtracts one more, allowing multiword subtraction chains.
    assign extended_difference = {1'b0, a} - {1'b0, b}
                               - {{WIDTH{1'b0}}, borrow_in};
    assign difference = extended_difference[WIDTH-1:0];
    assign borrow_out = extended_difference[WIDTH];
endmodule
