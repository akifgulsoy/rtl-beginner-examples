module pwm_generator #(
    parameter int PERIOD_CYCLES = 8,
    parameter int DUTY_CYCLES   = 3
) (
    input  logic clk,
    input  logic rst,
    output logic pwm_out
);
    localparam int COUNT_WIDTH = (PERIOD_CYCLES <= 1) ? 1 : $clog2(PERIOD_CYCLES);

    logic [COUNT_WIDTH-1:0] count;

    // pwm_out stays high for DUTY_CYCLES at the start of each period.
    always_ff @(posedge clk) begin
        if (rst) begin
            count   <= '0;
            pwm_out <= 1'b0;
        end else begin
            pwm_out <= (count < DUTY_CYCLES);

            if (count == PERIOD_CYCLES - 1)
                count <= '0;
            else
                count <= count + 1'b1;
        end
    end
endmodule
