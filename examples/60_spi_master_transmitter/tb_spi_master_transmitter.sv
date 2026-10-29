`timescale 1ns/1ps

module tb_spi_master_transmitter;
    logic clk = 1'b0;
    logic rst_n;
    logic spi_tick;
    logic start;
    logic [3:0] data;
    logic sclk;
    logic mosi;
    logic cs_n;
    logic busy;

    spi_master_transmitter #(.DATA_WIDTH(4)) dut (
        .clk(clk), .rst_n(rst_n), .spi_tick(spi_tick), .start(start),
        .data(data), .sclk(sclk), .mosi(mosi), .cs_n(cs_n), .busy(busy)
    );

    always #5 clk = ~clk;

    task automatic tick_and_expect(
        input logic expected_sclk,
        input logic expected_mosi,
        input logic expected_cs_n,
        input logic expected_busy
    );
        @(negedge clk);
        spi_tick = 1'b1;
        @(posedge clk);
        #1;
        if (sclk !== expected_sclk || mosi !== expected_mosi ||
            cs_n !== expected_cs_n || busy !== expected_busy)
            $fatal(1, "expected sclk=%b mosi=%b cs_n=%b busy=%b, got sclk=%b mosi=%b cs_n=%b busy=%b",
                   expected_sclk, expected_mosi, expected_cs_n, expected_busy,
                   sclk, mosi, cs_n, busy);
        @(negedge clk);
        spi_tick = 1'b0;
    endtask

    initial begin
        rst_n = 1'b0;
        spi_tick = 1'b0;
        start = 1'b0;
        data = '0;
        #1;
        if (sclk !== 1'b0 || cs_n !== 1'b1 || busy !== 1'b0)
            $fatal(1, "reset must leave the SPI bus idle");

        @(negedge clk);
        rst_n = 1'b1;
        start = 1'b1;
        data = 4'b1010;
        @(posedge clk);
        #1;
        if (sclk !== 1'b0 || mosi !== 1'b1 || cs_n !== 1'b0 || busy !== 1'b1)
            $fatal(1, "a transfer must select the slave and present the MSB");
        @(negedge clk);
        start = 1'b0;

        // Each bit is sampled at a rising edge and the next bit appears after falling.
        tick_and_expect(1'b1, 1'b1, 1'b0, 1'b1);
        tick_and_expect(1'b0, 1'b0, 1'b0, 1'b1);
        tick_and_expect(1'b1, 1'b0, 1'b0, 1'b1);

        // A busy-time request cannot replace the word currently being transmitted.
        @(negedge clk);
        start = 1'b1;
        data = 4'b0000;
        @(posedge clk);
        #1;
        if (mosi !== 1'b0 || cs_n !== 1'b0 || busy !== 1'b1)
            $fatal(1, "a busy SPI transmitter must ignore a new start request");
        @(negedge clk);
        start = 1'b0;

        tick_and_expect(1'b0, 1'b1, 1'b0, 1'b1);
        tick_and_expect(1'b1, 1'b1, 1'b0, 1'b1);
        tick_and_expect(1'b0, 1'b0, 1'b0, 1'b1);
        tick_and_expect(1'b1, 1'b0, 1'b0, 1'b1);
        tick_and_expect(1'b0, 1'b0, 1'b1, 1'b0);

        $display("PASS: spi_master_transmitter");
        $finish;
    end
endmodule
