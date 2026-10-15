module sticky_status_register #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic [WIDTH-1:0] event_set,
    input  logic [WIDTH-1:0] clear_mask,
    output logic [WIDTH-1:0] status
);
    // Status bits remember events until software clears them. An event wins
    // over a same-cycle clear so that no event is lost at the boundary.
    always_ff @(posedge clk) begin
        if (reset)
            status <= '0;
        else
            status <= (status & ~clear_mask) | event_set;
    end
endmodule
