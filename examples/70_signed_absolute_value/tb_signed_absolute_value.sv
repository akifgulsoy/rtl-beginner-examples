`timescale 1ns/1ps

module tb_signed_absolute_value;
    logic signed [3:0] value;
    logic        [3:0] magnitude;
    logic signed [0:0] narrow_value;
    logic        [0:0] narrow_magnitude;

    signed_absolute_value #(.WIDTH(4)) dut (
        .value(value), .magnitude(magnitude)
    );

    signed_absolute_value #(.WIDTH(1)) narrow_dut (
        .value(narrow_value), .magnitude(narrow_magnitude)
    );

    int unsigned expected;

    initial begin
        // Compute the reference in a wider type so +8 fits for the input -8.
        for (int sample = -8; sample <= 7; sample++) begin
            value = 4'(sample);
            expected = (sample < 0) ? -sample : sample;
            #1;
            if (magnitude !== expected)
                $fatal(1, "Input %0d: expected %0d, got %0d", sample, expected, magnitude);
        end

        // A one-bit signed word represents only 0 and -1.
        narrow_value = 1'b0;
        #1;
        if (narrow_magnitude !== 1'b0)
            $fatal(1, "One-bit zero must produce magnitude 0");

        narrow_value = 1'b1;
        #1;
        if (narrow_magnitude !== 1'b1)
            $fatal(1, "One-bit -1 must produce magnitude 1");

        $display("PASS: signed_absolute_value");
        $finish;
    end
endmodule
