`timescale 1ns/1ps

module tb_leading_zero_counter;
    logic [3:0] data_in;
    logic [2:0] leading_zero_count;
    logic [2:0] expected_count;
    integer value;
    integer bit_index;

    leading_zero_counter #(.WIDTH(4)) dut (
        .data_in(data_in),
        .leading_zero_count(leading_zero_count)
    );

    initial begin
        // Every 4-bit word checks the all-zero case and each possible first one.
        for (value = 0; value < 16; value = value + 1) begin
            data_in = value;
            expected_count = 3'd4;

            for (bit_index = 3; bit_index >= 0; bit_index = bit_index - 1) begin
                if (data_in[bit_index] && expected_count == 3'd4)
                    expected_count = 3 - bit_index;
            end

            #1;
            if (leading_zero_count !== expected_count)
                $fatal(1, "data %b: expected %0d leading zeros, got %0d",
                       data_in, expected_count, leading_zero_count);
        end

        $display("PASS: leading_zero_counter");
        $finish;
    end
endmodule
