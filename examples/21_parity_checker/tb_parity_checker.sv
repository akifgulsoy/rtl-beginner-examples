`timescale 1ns/1ps

module tb_parity_checker;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0] data_in;
    logic             parity_bit;
    logic             odd_parity;
    logic             parity_error;
    logic             expected_parity_bit;

    parity_checker #(.WIDTH(WIDTH)) dut (
        .data_in(data_in),
        .parity_bit(parity_bit),
        .odd_parity(odd_parity),
        .parity_error(parity_error)
    );

    task automatic check_word(
        input logic [WIDTH-1:0] value,
        input logic mode
    );
        data_in = value;
        odd_parity = mode;
        expected_parity_bit = (^value) ^ mode;

        // A correctly generated parity bit must not report an error.
        parity_bit = expected_parity_bit;
        #1;
        if (parity_error !== 1'b0)
            $fatal(1, "value=%b mode=%b: correct parity reported an error",
                   value, mode);

        // Flipping that bit models a single-bit error during transmission.
        parity_bit = ~expected_parity_bit;
        #1;
        if (parity_error !== 1'b1)
            $fatal(1, "value=%b mode=%b: incorrect parity was not detected",
                   value, mode);
    endtask

    initial begin
        // Check every 4-bit word with both even and odd parity conventions.
        for (int value = 0; value < 2**WIDTH; value++) begin
            check_word(value[WIDTH-1:0], 1'b0);
            check_word(value[WIDTH-1:0], 1'b1);
        end

        $display("PASS: parity_checker");
        $finish;
    end
endmodule
