`timescale 1ns/1ps

module tb_input_debouncer;
    logic clk = 1'b0;
    logic reset;
    logic noisy_in;
    logic clean_out;

    input_debouncer #(
        .SAMPLE_CYCLES(3)
    ) dut (
        .clk(clk),
        .reset(reset),
        .noisy_in(noisy_in),
        .clean_out(clean_out)
    );

    always #5 clk = ~clk;

    task automatic check_output(input logic expected);
        #1;
        if (clean_out !== expected)
            $fatal(1, "Expected clean_out=%b, got %b", expected, clean_out);
    endtask

    task automatic wait_clock_and_check(input logic expected);
        @(posedge clk);
        check_output(expected);
    endtask

    initial begin
        reset = 1'b1;
        noisy_in = 1'b0;
        wait_clock_and_check(1'b0);
        reset = 1'b0;

        // A one-cycle bounce must not change the filtered output.
        @(negedge clk);
        noisy_in = 1'b1;
        wait_clock_and_check(1'b0);
        @(negedge clk);
        noisy_in = 1'b0;
        wait_clock_and_check(1'b0);

        // Three consecutive samples accept a new stable high level.
        @(negedge clk);
        noisy_in = 1'b1;
        wait_clock_and_check(1'b0);
        wait_clock_and_check(1'b0);
        wait_clock_and_check(1'b1);

        // A short low bounce is ignored while the output remains high.
        @(negedge clk);
        noisy_in = 1'b0;
        wait_clock_and_check(1'b1);
        @(negedge clk);
        noisy_in = 1'b1;
        wait_clock_and_check(1'b1);

        // A stable low level is accepted after the same three samples.
        @(negedge clk);
        noisy_in = 1'b0;
        wait_clock_and_check(1'b1);
        wait_clock_and_check(1'b1);
        wait_clock_and_check(1'b0);

        $display("PASS: input_debouncer");
        $finish;
    end
endmodule
