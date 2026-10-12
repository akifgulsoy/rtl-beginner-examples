`timescale 1ns/1ps

module tb_synchronous_rom;
    logic clk = 1'b0;
    logic [1:0] address;
    logic [7:0] read_data;

    synchronous_rom dut (
        .clk(clk),
        .address(address),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    task automatic read_word(
        input logic [1:0] requested_address,
        input logic [7:0] expected_data
    );
        @(negedge clk);
        address = requested_address;
        @(posedge clk);
        #1;
        if (read_data !== expected_data)
            $fatal(1, "address %0d: expected %h, got %h",
                   requested_address, expected_data, read_data);
    endtask

    initial begin
        address = '0;

        read_word(2'd0, 8'h3c);
        read_word(2'd1, 8'ha5);
        read_word(2'd2, 8'h5a);
        read_word(2'd3, 8'hc3);

        // An address change alone cannot change a synchronous ROM output.
        @(negedge clk);
        address = 2'd0;
        #1;
        if (read_data !== 8'hc3)
            $fatal(1, "read data changed before the next clock edge");
        @(posedge clk);
        #1;
        if (read_data !== 8'h3c)
            $fatal(1, "next clock edge did not register address 0 data");

        $display("PASS: synchronous_rom");
        $finish;
    end
endmodule
