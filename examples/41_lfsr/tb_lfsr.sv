`timescale 1ns/1ps

module tb_lfsr;
    logic clk;
    logic rst_n;
    logic enable;
    logic [3:0] value;
    logic [3:0] expected_value;
    integer step;

    lfsr dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .value(value)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        enable = 1'b0;

        #1;
        if (value !== 4'b0001)
            $fatal(1, "reset: expected 0001, got %b", value);

        rst_n = 1'b1;
        enable = 1'b1;
        expected_value = 4'b0001;

        // A maximal-length 4-bit LFSR visits 15 non-zero states before repeating.
        for (step = 0; step < 15; step = step + 1) begin
            @(posedge clk);
            #1;
            expected_value = {expected_value[2:0],
                              expected_value[3] ^ expected_value[2]};
            if (value !== expected_value)
                $fatal(1, "step %0d: expected %b, got %b",
                       step, expected_value, value);
            if (value === 4'b0000)
                $fatal(1, "step %0d: LFSR entered the all-zero lockup state", step);
        end

        if (value !== 4'b0001)
            $fatal(1, "sequence did not repeat: got %b", value);

        enable = 1'b0;
        @(posedge clk);
        #1;
        if (value !== 4'b0001)
            $fatal(1, "disabled LFSR changed to %b", value);

        $display("PASS: lfsr");
        $finish;
    end
endmodule
