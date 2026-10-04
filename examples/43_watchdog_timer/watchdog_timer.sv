module watchdog_timer #(
    parameter int CYCLES = 4
) (
    input  logic clk,
    input  logic rst,
    input  logic kick,
    output logic timeout
);
    localparam int COUNT_WIDTH = (CYCLES <= 1) ? 1 : $clog2(CYCLES);

    logic [COUNT_WIDTH-1:0] count;

    always_ff @(posedge clk) begin
        if (rst) begin
            count   <= '0;
            timeout <= 1'b0;
        end else if (kick) begin
            // A service event restarts the watchdog period.
            count   <= '0;
            timeout <= 1'b0;
        end else if (count == CYCLES - 1) begin
            // Once expired, remain timed out until reset or a new kick.
            timeout <= 1'b1;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule
