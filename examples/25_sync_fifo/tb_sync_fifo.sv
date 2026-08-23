`timescale 1ns/1ps

module tb_sync_fifo;
    logic clk = 1'b0;
    logic rst_n;
    logic write_en;
    logic [7:0] write_data;
    logic read_en;
    logic [7:0] read_data;
    logic full;
    logic empty;

    sync_fifo #(.DATA_WIDTH(8), .ADDR_WIDTH(2)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .write_en(write_en),
        .write_data(write_data),
        .read_en(read_en),
        .read_data(read_data),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    task automatic write_word(input logic [7:0] word);
        @(negedge clk);
        write_en = 1'b1;
        write_data = word;
        @(negedge clk);
        write_en = 1'b0;
    endtask

    task automatic read_word(input logic [7:0] expected_word);
        @(negedge clk);
        read_en = 1'b1;
        @(posedge clk);
        #1;
        if (read_data !== expected_word)
            $fatal(1, "expected read_data=%h, got %h", expected_word, read_data);
        @(negedge clk);
        read_en = 1'b0;
    endtask

    initial begin
        rst_n = 1'b0;
        write_en = 1'b0;
        write_data = '0;
        read_en = 1'b0;
        #1;
        if (!empty || full || read_data !== 8'h00)
            $fatal(1, "reset must produce an empty FIFO with zero read_data");

        @(negedge clk);
        rst_n = 1'b1;

        // Reads from an empty FIFO are ignored.
        read_word(8'h00);
        if (!empty)
            $fatal(1, "an empty-FIFO read must not change occupancy");

        // Data exits in the same first-in, first-out order it entered.
        write_word(8'h11);
        write_word(8'h22);
        write_word(8'h33);
        read_word(8'h11);
        read_word(8'h22);

        // Fill all four entries; an extra write must be ignored while full.
        write_word(8'h44);
        write_word(8'h55);
        write_word(8'h66);
        if (!full)
            $fatal(1, "FIFO must assert full after four stored words");
        write_word(8'h77);
        read_word(8'h33);
        read_word(8'h44);
        read_word(8'h55);
        read_word(8'h66);

        if (!empty || full)
            $fatal(1, "FIFO must be empty after all stored words are read");

        $display("PASS: sync_fifo");
        $finish;
    end
endmodule
