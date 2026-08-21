`timescale 1ns/1ps

module tb_one_hot_decoder;
    localparam int INDEX_WIDTH = 3;
    localparam int OUTPUT_WIDTH = 1 << INDEX_WIDTH;

    logic [INDEX_WIDTH-1:0] index;
    logic                   enable;
    logic [OUTPUT_WIDTH-1:0] decoded;

    one_hot_decoder #(.INDEX_WIDTH(INDEX_WIDTH)) dut (
        .index(index),
        .enable(enable),
        .decoded(decoded)
    );

    task automatic check(
        input logic [INDEX_WIDTH-1:0] input_index,
        input logic                   input_enable,
        input logic [OUTPUT_WIDTH-1:0] expected_decoded
    );
        index = input_index;
        enable = input_enable;
        #1;

        if (decoded !== expected_decoded)
            $fatal(1, "index=%0d enable=%b: expected decoded=%b, got %b",
                   input_index, input_enable, expected_decoded, decoded);
    endtask

    initial begin
        // Disabled decoding must keep every output low for every index.
        for (int value = 0; value < OUTPUT_WIDTH; value++) begin
            check(value[INDEX_WIDTH-1:0], 1'b0, '0);
        end

        // Enabled decoding must produce exactly one high output bit.
        for (int value = 0; value < OUTPUT_WIDTH; value++) begin
            check(value[INDEX_WIDTH-1:0], 1'b1, OUTPUT_WIDTH'(1) << value);
        end

        $display("PASS: one_hot_decoder");
        $finish;
    end
endmodule
