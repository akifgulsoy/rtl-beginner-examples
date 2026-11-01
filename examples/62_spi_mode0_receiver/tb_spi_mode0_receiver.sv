`timescale 1ns/1ps

module tb_spi_mode0_receiver;
    logic rst_n;
    logic sclk;
    logic cs_n;
    logic mosi;
    logic [3:0] data;
    logic data_valid;

    spi_mode0_receiver #(.DATA_WIDTH(4)) dut (
        .rst_n(rst_n), .sclk(sclk), .cs_n(cs_n), .mosi(mosi),
        .data(data), .data_valid(data_valid)
    );

    task automatic sample_bit(input logic bit_value);
        mosi = bit_value;
        #5 sclk = 1'b1;
        #1 sclk = 1'b0;
    endtask

    initial begin
        rst_n = 1'b0;
        sclk = 1'b0;
        cs_n = 1'b1;
        mosi = 1'b0;
        #1;
        if (data !== '0 || data_valid !== 1'b0)
            $fatal(1, "reset must clear received data and valid");

        rst_n = 1'b1;

        // Clocks while deselected must not collect a word.
        sample_bit(1'b1);
        if (data_valid !== 1'b0)
            $fatal(1, "a deselected receiver must ignore SCLK edges");

        // Mode 0 receives the MSB first on each rising SCLK edge.
        cs_n = 1'b0;
        sample_bit(1'b1);
        sample_bit(1'b0);
        sample_bit(1'b1);
        if (data_valid !== 1'b0)
            $fatal(1, "valid must remain low until a complete word arrives");
        sample_bit(1'b0);
        if (data !== 4'b1010 || data_valid !== 1'b1)
            $fatal(1, "expected completed SPI word 1010 and valid pulse");

        // The next edge starts a new word and clears the one-edge valid indication.
        sample_bit(1'b0);
        if (data_valid !== 1'b0 || data !== 4'b1010)
            $fatal(1, "a new partial word must clear valid and retain prior data");

        // Ending a transfer discards an incomplete word and prepares a fresh frame.
        cs_n = 1'b1;
        #1;
        if (data_valid !== 1'b0)
            $fatal(1, "deselecting the receiver must clear valid");
        cs_n = 1'b0;
        sample_bit(1'b0);
        sample_bit(1'b1);
        sample_bit(1'b1);
        sample_bit(1'b0);
        if (data !== 4'b0110 || data_valid !== 1'b1)
            $fatal(1, "a new frame must not include bits from the prior frame");

        $display("PASS: spi_mode0_receiver");
        $finish;
    end
endmodule
