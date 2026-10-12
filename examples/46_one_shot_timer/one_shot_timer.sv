module one_shot_timer #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             reset,
    input  logic             start,
    input  logic [WIDTH-1:0] delay_cycles,
    output logic             active,
    output logic             done
);
    logic [WIDTH-1:0] count;

    // A start request is accepted only while idle. A zero delay completes at once.
    always_ff @(posedge clk) begin
        if (reset) begin
            count  <= '0;
            active <= 1'b0;
            done   <= 1'b0;
        end else begin
            done <= 1'b0;

            if (!active && start) begin
                if (delay_cycles == '0) begin
                    done <= 1'b1;
                end else begin
                    count  <= delay_cycles;
                    active <= 1'b1;
                end
            end else if (active) begin
                if (count == {{(WIDTH-1){1'b0}}, 1'b1}) begin
                    count  <= '0;
                    active <= 1'b0;
                    done   <= 1'b1;
                end else begin
                    count <= count - 1'b1;
                end
            end
        end
    end
endmodule
