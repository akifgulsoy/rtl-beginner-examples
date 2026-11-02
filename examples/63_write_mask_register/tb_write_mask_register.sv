`timescale 1ns/1ps

module tb_write_mask_register;
    logic clk;
    logic rst_n;
    logic write_en;
    logic [7:0] write_data;
    logic [7:0] write_mask;
    logic [7:0] value;

    write_mask_register dut (
        .clk(clk), .rst_n(rst_n), .write_en(write_en),
        .write_data(write_data), .write_mask(write_mask), .value(value)
    );

    always #5 clk = ~clk;

    task automatic write_bits(
        input logic [7:0] data,
        input logic [7:0] mask
    );
        write_data = data;
        write_mask = mask;
        write_en   = 1'b1;
        @(posedge clk);
        #1;
        write_en = 1'b0;
    endtask

    initial begin
        clk        = 1'b0;
        rst_n      = 1'b0;
        write_en   = 1'b0;
        write_data = '0;
        write_mask = '0;
        #1;
        if (value !== 8'h00)
            $fatal(1, "reset must clear the register");

        rst_n = 1'b1;

        // A full mask loads every bit.
        write_bits(8'hA5, 8'hFF);
        if (value !== 8'hA5)
            $fatal(1, "a full mask must load all bits");

        // Only low-nibble bits change; high-nibble bits retain their value.
        write_bits(8'h3C, 8'h0F);
        if (value !== 8'hAC)
            $fatal(1, "a partial mask must preserve unmasked bits");

        // A zero mask changes nothing even when a write is requested.
        write_bits(8'h00, 8'h00);
        if (value !== 8'hAC)
            $fatal(1, "a zero mask must preserve the whole register");

        // No write request also holds the previous value.
        write_data = 8'hFF;
        write_mask = 8'hFF;
        @(posedge clk);
        #1;
        if (value !== 8'hAC)
            $fatal(1, "the register must hold its value without write_en");

        $display("PASS: write_mask_register");
        $finish;
    end
endmodule
