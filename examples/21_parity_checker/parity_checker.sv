module parity_checker #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] data_in,
    input  logic             parity_bit,
    input  logic             odd_parity,
    output logic             parity_error
);
    logic expected_parity_bit;

    // A reduction XOR is 1 when data_in contains an odd number of 1 bits.
    // For even parity, the parity bit makes the total number of 1 bits even.
    always_comb begin
        expected_parity_bit = (^data_in) ^ odd_parity;
        parity_error = parity_bit != expected_parity_bit;
    end
endmodule
