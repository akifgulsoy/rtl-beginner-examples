`timescale 1ns/1ps

module tb_clock_divider;
    localparam int HALF_PERIOD = 3;

    logic clk = 1'b0;
    logic rst;
    logic clk_out;

    clock_divider #(.HALF_PERIOD(HALF_PERIOD)) dut (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );

    always #5 clk = ~clk;

    task automatic check_output(input logic expected, input string label);
        if (clk_out !== expected)
            $fatal(1, "%s: expected clk_out=%b, got %b", label, expected, clk_out);
    endtask

    initial begin
        rst = 1'b1;
        @(posedge clk);
        #1;
        check_output(1'b0, "reset forces output low");

        rst = 1'b0;
        // The output holds for HALF_PERIOD input-clock edges before toggling.
        repeat (HALF_PERIOD - 1) begin
            @(posedge clk);
            #1;
            check_output(1'b0, "output stays low during first half period");
        end
        @(posedge clk);
        #1;
        check_output(1'b1, "output rises after first half period");

        repeat (HALF_PERIOD - 1) begin
            @(posedge clk);
            #1;
            check_output(1'b1, "output stays high during second half period");
        end
        @(posedge clk);
        #1;
        check_output(1'b0, "output falls after second half period");

        // Reset restarts the divider immediately on the next input clock edge.
        rst = 1'b1;
        @(posedge clk);
        #1;
        check_output(1'b0, "reset clears a running divider");

        $display("PASS: clock_divider");
        $finish;
    end
endmodule
