`timescale 1ns/1ps

module tb_synchronous_ram;
    logic clk = 1'b0;
    logic enable = 1'b0;
    logic write_en = 1'b0;
    logic [1:0] address = '0;
    logic [7:0] write_data = '0;
    logic [7:0] read_data;

    synchronous_ram #(.ADDR_WIDTH(2)) dut (
        .clk(clk), .enable(enable), .write_en(write_en),
        .address(address), .write_data(write_data), .read_data(read_data)
    );

    always #5 clk = ~clk;

    task automatic cycle(
        input logic en,
        input logic wr,
        input logic [1:0] addr,
        input logic [7:0] data
    );
        @(negedge clk);
        enable = en;
        write_en = wr;
        address = addr;
        write_data = data;
        @(posedge clk);
        #1;
    endtask

    task automatic expect_data(input logic [7:0] expected, input string label);
        if (read_data !== expected)
            $fatal(1, "%s: expected %h, got %h", label, expected, read_data);
    endtask

    initial begin
        // Initial contents and output are unspecified; initialize before reading.
        cycle(1, 1, 0, 8'hA5);
        cycle(1, 1, 3, 8'h3C);
        cycle(1, 0, 0, 0);
        expect_data(8'hA5, "read first address");

        // Unlike asynchronous RAM, changing address alone cannot change output.
        @(negedge clk);
        address = 3;
        #1;
        expect_data(8'hA5, "output holds before the read edge");
        @(posedge clk);
        #1;
        expect_data(8'h3C, "read last address on clock edge");

        cycle(1, 1, 3, 8'hF0);
        expect_data(8'h3C, "read-before-write returns old data");
        cycle(1, 0, 3, 0);
        expect_data(8'hF0, "next read returns newly written data");

        cycle(0, 1, 0, 8'hFF);
        expect_data(8'hF0, "disabled write holds output");
        cycle(0, 0, 0, 0);
        expect_data(8'hF0, "disabled read holds output");
        cycle(1, 0, 0, 0);
        expect_data(8'hA5, "disabled write preserved memory");
        cycle(1, 0, 3, 0);
        expect_data(8'hF0, "writes do not alter other addresses");

        $display("PASS: synchronous_ram");
        $finish;
    end
endmodule
