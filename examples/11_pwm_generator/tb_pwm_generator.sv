`timescale 1ns/1ps

module tb_pwm_generator;
    logic clk = 1'b0;
    logic rst;
    logic pwm_out;

    pwm_generator #(
        .PERIOD_CYCLES(8),
        .DUTY_CYCLES(3)
    ) dut (
        .clk(clk),
        .rst(rst),
        .pwm_out(pwm_out)
    );

    always #5 clk = ~clk;

    task automatic check_pwm(input logic expected);
        #1;
        if (pwm_out !== expected)
            $fatal(1, "Expected pwm_out=%b, got %b", expected, pwm_out);
    endtask

    task automatic check_period;
        repeat (3) begin
            @(posedge clk);
            check_pwm(1'b1);
        end

        repeat (5) begin
            @(posedge clk);
            check_pwm(1'b0);
        end
    endtask

    initial begin
        rst = 1'b1;
        @(posedge clk);
        check_pwm(1'b0);

        @(negedge clk);
        rst = 1'b0;

        // An 8-cycle period has a three-cycle high duty portion.
        check_period();

        // Verify that the waveform repeats on the next complete period.
        check_period();

        $display("PASS: pwm_generator");
        $finish;
    end
endmodule
