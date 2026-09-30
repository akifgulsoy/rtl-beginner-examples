`timescale 1ns/1ps

module tb_crc8_serial;
    logic       clk = 1'b0;
    logic       reset;
    logic       clear;
    logic       enable;
    logic       data_bit;
    logic [7:0] crc;

    crc8_serial dut (
        .clk(clk),
        .reset(reset),
        .clear(clear),
        .enable(enable),
        .data_bit(data_bit),
        .crc(crc)
    );

    always #5 clk = ~clk;

    task automatic send_byte_msb_first(input logic [7:0] value);
        begin
            for (int bit_index = 7; bit_index >= 0; bit_index--) begin
                @(negedge clk);
                data_bit = value[bit_index];
                enable = 1'b1;
                @(negedge clk);
                enable = 1'b0;
            end
        end
    endtask

    initial begin
        reset = 1'b1;
        clear = 1'b0;
        enable = 1'b0;
        data_bit = 1'b0;

        @(posedge clk);
        #1;
        if (crc !== 8'h00)
            $fatal(1, "reset did not clear the CRC");

        @(negedge clk);
        reset = 1'b0;

        // CRC-8/ATM of ASCII "123456789", processed MSB first, is 8'hF4.
        send_byte_msb_first("1");
        send_byte_msb_first("2");
        send_byte_msb_first("3");
        send_byte_msb_first("4");
        send_byte_msb_first("5");
        send_byte_msb_first("6");
        send_byte_msb_first("7");
        send_byte_msb_first("8");
        send_byte_msb_first("9");
        if (crc !== 8'hF4)
            $fatal(1, "expected CRC-8/ATM F4, got %02h", crc);

        // With enable low, input changes do not affect the saved CRC.
        data_bit = 1'b1;
        repeat (2) @(posedge clk);
        #1;
        if (crc !== 8'hF4)
            $fatal(1, "CRC changed while disabled");

        @(negedge clk);
        clear = 1'b1;
        @(posedge clk);
        #1;
        if (crc !== 8'h00)
            $fatal(1, "clear did not reset the CRC");
        @(negedge clk);
        clear = 1'b0;

        $display("PASS: crc8_serial");
        $finish;
    end
endmodule
