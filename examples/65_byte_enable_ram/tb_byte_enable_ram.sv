`timescale 1ns/1ps

module tb_byte_enable_ram;
    logic clk = 1'b0;
    logic enable = 1'b0;
    logic [2:0] byte_en = '0;
    logic [1:0] address = '0;
    logic [23:0] write_data = '0;
    logic [23:0] read_data;

    byte_enable_ram #(.BYTE_COUNT(3), .ADDR_WIDTH(2)) dut (
        .clk(clk), .enable(enable), .byte_en(byte_en),
        .address(address), .write_data(write_data), .read_data(read_data)
    );

    always #5 clk = ~clk;

    task automatic access_word(
        input logic en,
        input logic [2:0] mask,
        input logic [1:0] addr,
        input logic [23:0] data
    );
        @(negedge clk);
        enable = en;
        byte_en = mask;
        address = addr;
        write_data = data;
        @(posedge clk);
        #1;
    endtask

    task automatic expect_data(input logic [23:0] expected, input string label);
        if (read_data !== expected)
            $fatal(1, "%s: expected %h, got %h", label, expected, read_data);
    endtask

    initial begin
        access_word(1, 3'b111, 0, 24'h12_34_56);
        access_word(1, 3'b111, 3, 24'hAB_CD_EF);

        // Update the outer bytes while retaining the middle byte.
        access_word(1, 3'b101, 0, 24'hA1_B2_C3);
        expect_data(24'h12_34_56, "write returns the old word");
        access_word(1, 3'b000, 0, 24'hFF_FF_FF);
        expect_data(24'hA1_34_C3, "outer bytes updated");

        access_word(1, 3'b010, 0, 24'hD4_E5_F6);
        expect_data(24'hA1_34_C3, "zero mask preserved the word");
        access_word(1, 3'b000, 0, '0);
        expect_data(24'hA1_E5_C3, "middle byte updated");

        access_word(0, 3'b111, 3, 24'h00_00_00);
        expect_data(24'hA1_E5_C3, "disabled access holds the output");
        access_word(1, 3'b000, 3, '0);
        expect_data(24'hAB_CD_EF, "other address remains intact");

        $display("PASS: byte_enable_ram");
        $finish;
    end
endmodule
