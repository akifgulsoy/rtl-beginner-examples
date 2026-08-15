`timescale 1ns/1ps

module tb_binary_to_gray;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0] binary;
    logic [WIDTH-1:0] gray;

    binary_to_gray #(.WIDTH(WIDTH)) dut (
        .binary(binary),
        .gray(gray)
    );

    initial begin
        // Check every possible input value against the Gray-code equation.
        for (int value = 0; value < (1 << WIDTH); value++) begin
            logic [WIDTH-1:0] expected_gray;

            binary = value[WIDTH-1:0];
            expected_gray = binary ^ (binary >> 1);
            #1;

            if (gray !== expected_gray)
                $fatal(1, "binary=%b: expected gray=%b, got %b",
                       binary, expected_gray, gray);
        end

        $display("PASS: binary_to_gray");
        $finish;
    end
endmodule
