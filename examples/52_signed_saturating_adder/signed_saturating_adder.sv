module signed_saturating_adder #(
    parameter int WIDTH = 8 // WIDTH must be at least 2.
) (
    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,
    output logic signed [WIDTH-1:0] result
);
    logic signed [WIDTH-1:0] sum;

    assign sum = a + b;

    // Equal input signs with a different result sign indicate overflow.
    always_comb begin
        if ((a[WIDTH-1] == b[WIDTH-1]) && (sum[WIDTH-1] != a[WIDTH-1])) begin
            if (a[WIDTH-1])
                result = {1'b1, {(WIDTH-1){1'b0}}}; // Minimum signed value.
            else
                result = {1'b0, {(WIDTH-1){1'b1}}}; // Maximum signed value.
        end else begin
            result = sum;
        end
    end
endmodule
