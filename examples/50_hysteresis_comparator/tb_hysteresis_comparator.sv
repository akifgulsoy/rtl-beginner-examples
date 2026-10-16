`timescale 1ns/1ps

module tb_hysteresis_comparator;
    logic clk = 1'b0;
    logic reset;
    logic [3:0] sample;
    logic alert;

    hysteresis_comparator #(
        .WIDTH(4),
        .ASSERT_LEVEL(4'd10),
        .DEASSERT_LEVEL(4'd6)
    ) dut (
        .clk(clk),
        .reset(reset),
        .sample(sample),
        .alert(alert)
    );

    always #5 clk = ~clk;

    task automatic expect_alert(input logic expected, input string label);
        #1;
        if (alert !== expected)
            $fatal(1, "%s: expected alert=%b, got %b", label, expected, alert);
    endtask

    initial begin
        reset  = 1'b1;
        sample = '0;
        @(posedge clk);
        expect_alert(1'b0, "reset clears alert");

        @(negedge clk);
        reset  = 1'b0;
        sample = 4'd9;
        @(posedge clk);
        expect_alert(1'b0, "sample below assert level keeps alert low");

        @(negedge clk);
        sample = 4'd10;
        @(posedge clk);
        expect_alert(1'b1, "sample at assert level raises alert");

        // Values between the thresholds retain the prior alert state.
        @(negedge clk);
        sample = 4'd8;
        @(posedge clk);
        expect_alert(1'b1, "middle-band sample holds alert high");

        @(negedge clk);
        sample = 4'd7;
        @(posedge clk);
        expect_alert(1'b1, "alert stays high above deassert level");

        @(negedge clk);
        sample = 4'd6;
        @(posedge clk);
        expect_alert(1'b0, "sample at deassert level lowers alert");

        @(negedge clk);
        sample = 4'd15;
        @(posedge clk);
        expect_alert(1'b1, "a later high sample raises alert again");

        $display("PASS: hysteresis_comparator");
        $finish;
    end
endmodule
