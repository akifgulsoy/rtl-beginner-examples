module reset_synchronizer #(
    parameter int STAGES = 2
) (
    input  logic clk,
    input  logic async_reset_n,
    output logic reset_n
);
    logic [STAGES-1:0] release_pipe;

    // Assertion is immediate; deassertion waits for STAGES clock edges.
    always_ff @(posedge clk or negedge async_reset_n) begin
        if (!async_reset_n)
            release_pipe <= '0;
        else
            release_pipe <= {release_pipe[STAGES-2:0], 1'b1};
    end

    assign reset_n = release_pipe[STAGES-1];
endmodule
