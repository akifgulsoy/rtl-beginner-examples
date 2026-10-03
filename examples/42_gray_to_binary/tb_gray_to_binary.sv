`timescale 1ns/1ps

module tb_gray_to_binary;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0] gray;
    logic [WIDTH-1:0] binary;

    gray_to_binary #(.WIDTH(WIDTH)) dut (
        .gray(gray),
        .binary(binary)
    );

    initial begin
        // Convert every Gray-coded 4-bit binary value back to its source value.
        for (int value = 0; value < (1 << WIDTH); value++) begin
            gray = value[WIDTH-1:0] ^ (value[WIDTH-1:0] >> 1);
            #1;

            if (binary !== value[WIDTH-1:0])
                $fatal(1, "gray=%b: expected binary=%b, got %b",
                       gray, value[WIDTH-1:0], binary);
        end

        $display("PASS: gray_to_binary");
        $finish;
    end
endmodule
