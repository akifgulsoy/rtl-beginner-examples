`timescale 1ns/1ps

module tb_population_counter;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0] data_in;
    logic [2:0]       one_count;
    logic [2:0]       expected_count;
    integer value;
    integer bit_index;

    population_counter #(.WIDTH(WIDTH)) dut (
        .data_in(data_in),
        .one_count(one_count)
    );

    initial begin
        // Every 4-bit word covers all possible numbers of asserted bits.
        for (value = 0; value < 2**WIDTH; value = value + 1) begin
            data_in = value[WIDTH-1:0];
            expected_count = '0;

            for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1)
                expected_count = expected_count + data_in[bit_index];

            #1;
            if (one_count !== expected_count)
                $fatal(1, "data %b: expected %0d ones, got %0d",
                       data_in, expected_count, one_count);
        end

        $display("PASS: population_counter");
        $finish;
    end
endmodule
