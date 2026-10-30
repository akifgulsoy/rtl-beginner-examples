`timescale 1ns/1ps

module tb_simple_dual_port_ram;
    logic clk = 1'b0;
    logic write_en;
    logic [2:0] write_address;
    logic [7:0] write_data;
    logic [2:0] read_address;
    logic [7:0] read_data;

    simple_dual_port_ram #(.DATA_WIDTH(8), .ADDR_WIDTH(3)) dut (
        .clk(clk), .write_en(write_en), .write_address(write_address),
        .write_data(write_data), .read_address(read_address), .read_data(read_data)
    );

    always #5 clk = ~clk;

    task automatic write_word(
        input logic [2:0] target_address,
        input logic [7:0] word
    );
        @(negedge clk);
        write_address = target_address;
        write_data = word;
        write_en = 1'b1;
        @(posedge clk);
        @(negedge clk);
        write_en = 1'b0;
    endtask

    initial begin
        write_en = 1'b0;
        write_address = '0;
        write_data = '0;
        read_address = '0;

        write_word(3'd1, 8'h3c);
        write_word(3'd6, 8'ha5);

        // The read port can select either stored word without a clock edge.
        #1 read_address = 3'd1;
        #1 if (read_data !== 8'h3c)
            $fatal(1, "address 1 should read 3c, got %h", read_data);
        #1 read_address = 3'd6;
        #1 if (read_data !== 8'ha5)
            $fatal(1, "address 6 should read a5, got %h", read_data);

        // Reading address 1 continues to work while address 6 is overwritten.
        @(negedge clk);
        read_address = 3'd1;
        write_address = 3'd6;
        write_data = 8'h5a;
        write_en = 1'b1;
        #1 if (read_data !== 8'h3c)
            $fatal(1, "a write on another address changed the active read port");
        @(posedge clk);
        #1 if (read_data !== 8'h3c)
            $fatal(1, "the read port lost address 1 during a write");
        @(negedge clk);
        write_en = 1'b0;

        #1 read_address = 3'd6;
        #1 if (read_data !== 8'h5a)
            $fatal(1, "address 6 should contain overwritten value 5a, got %h", read_data);

        // Write data must not appear until the next write clock edge.
        @(negedge clk);
        write_address = 3'd1;
        write_data = 8'hc3;
        read_address = 3'd1;
        write_en = 1'b1;
        #1 if (read_data !== 8'h3c)
            $fatal(1, "memory changed before the write clock edge");
        @(posedge clk);
        #1 if (read_data !== 8'hc3)
            $fatal(1, "address 1 should contain c3 after its write, got %h", read_data);

        $display("PASS: simple_dual_port_ram");
        $finish;
    end
endmodule
