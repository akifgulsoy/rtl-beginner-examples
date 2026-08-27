`timescale 1ns/1ps

module tb_single_port_ram;
    logic clk = 1'b0;
    logic write_en;
    logic [2:0] address;
    logic [7:0] write_data;
    logic [7:0] read_data;

    single_port_ram #(.DATA_WIDTH(8), .ADDR_WIDTH(3)) dut (
        .clk(clk),
        .write_en(write_en),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    task automatic write_word(
        input logic [2:0] target_address,
        input logic [7:0] word
    );
        @(negedge clk);
        address = target_address;
        write_data = word;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        if (read_data !== word)
            $fatal(1, "write at address %0d failed: expected %h, got %h",
                   target_address, word, read_data);
        @(negedge clk);
        write_en = 1'b0;
    endtask

    initial begin
        write_en = 1'b0;
        address = '0;
        write_data = '0;

        write_word(3'd0, 8'h3c);
        write_word(3'd3, 8'ha5);
        write_word(3'd7, 8'h5a);

        // Changing address changes the asynchronous read value immediately.
        #1 address = 3'd0;
        #1 if (read_data !== 8'h3c)
            $fatal(1, "address 0 should read 3c, got %h", read_data);
        #1 address = 3'd3;
        #1 if (read_data !== 8'ha5)
            $fatal(1, "address 3 should read a5, got %h", read_data);
        #1 address = 3'd7;
        #1 if (read_data !== 8'h5a)
            $fatal(1, "address 7 should read 5a, got %h", read_data);

        // New write data does not change memory until the following clock edge.
        @(negedge clk);
        address = 3'd0;
        write_data = 8'hc3;
        write_en = 1'b1;
        #1 if (read_data !== 8'h3c)
            $fatal(1, "memory changed before its write clock edge");
        @(posedge clk);
        #1 if (read_data !== 8'hc3)
            $fatal(1, "overwrite at address 0 failed: got %h", read_data);
        @(negedge clk);
        write_en = 1'b0;

        $display("PASS: single_port_ram");
        $finish;
    end
endmodule
