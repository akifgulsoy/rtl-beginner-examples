`timescale 1ns/1ps

module tb_signed_saturating_resize;
    logic signed [4:0] value;
    logic signed [2:0] result;
    logic signed [0:0] one_bit_result;
    logic signed [4:0] same_width_result;

    signed_saturating_resize #(.IN_WIDTH(5), .OUT_WIDTH(3)) dut (
        .value(value), .result(result)
    );

    signed_saturating_resize #(.IN_WIDTH(5), .OUT_WIDTH(1)) one_bit_dut (
        .value(value), .result(one_bit_result)
    );

    signed_saturating_resize #(.IN_WIDTH(5), .OUT_WIDTH(5)) same_width_dut (
        .value(value), .result(same_width_result)
    );

    int expected;

    initial begin
        for (int sample = -16; sample <= 15; sample++) begin
            value = 5'(sample);
            expected = (sample < -4) ? -4 : (sample > 3) ? 3 : sample;
            #1;
            if (result !== expected)
                $fatal(1, "Input %0d: expected %0d, got %0d", sample, expected, result);

            // A one-bit signed output can only represent -1 and 0.
            if (one_bit_result !== ((sample < 0) ? 1'b1 : 1'b0))
                $fatal(1, "Input %0d: incorrect one-bit result %0d", sample, one_bit_result);

            if (same_width_result !== value)
                $fatal(1, "Input %0d changed at the same width: %0d", sample, same_width_result);
        end

        $display("PASS: signed_saturating_resize");
        $finish;
    end
endmodule
