`timescale 1ns/1ps

module tb_register_file;
    logic clk = 1'b0;
    logic write_en;
    logic [2:0] write_address;
    logic [7:0] write_data;
    logic [2:0] read_address_a;
    logic [2:0] read_address_b;
    logic [7:0] read_data_a;
    logic [7:0] read_data_b;

    register_file #(.DATA_WIDTH(8), .ADDR_WIDTH(3)) dut (
        .clk(clk),
        .write_en(write_en),
        .write_address(write_address),
        .write_data(write_data),
        .read_address_a(read_address_a),
        .read_address_b(read_address_b),
        .read_data_a(read_data_a),
        .read_data_b(read_data_b)
    );

    always #5 clk = ~clk;

    task automatic write_register(
        input logic [2:0] target_address,
        input logic [7:0] word
    );
        @(negedge clk);
        write_address = target_address;
        write_data = word;
        write_en = 1'b1;
        @(posedge clk);
        #1;
        @(negedge clk);
        write_en = 1'b0;
    endtask

    initial begin
        write_en = 1'b0;
        write_address = '0;
        write_data = '0;
        read_address_a = '0;
        read_address_b = '0;

        write_register(3'd1, 8'h12);
        write_register(3'd4, 8'h4a);
        write_register(3'd6, 8'hc3);

        // The two ports can read different registers at the same time.
        #1;
        read_address_a = 3'd1;
        read_address_b = 3'd4;
        #1;
        if (read_data_a !== 8'h12 || read_data_b !== 8'h4a)
            $fatal(1, "independent reads failed: got %h and %h", read_data_a, read_data_b);

        // Each read port changes immediately when only its address changes.
        read_address_a = 3'd6;
        #1;
        if (read_data_a !== 8'hc3 || read_data_b !== 8'h4a)
            $fatal(1, "address-selected reads failed: got %h and %h", read_data_a, read_data_b);

        // A pending write does not alter either read port before its clock edge.
        @(negedge clk);
        write_address = 3'd4;
        write_data = 8'h99;
        write_en = 1'b1;
        #1;
        if (read_data_b !== 8'h4a)
            $fatal(1, "register changed before its write clock edge");
        @(posedge clk);
        #1;
        if (read_data_b !== 8'h99)
            $fatal(1, "overwrite failed: expected 99, got %h", read_data_b);
        @(negedge clk);
        write_en = 1'b0;

        // Disabling writes preserves the stored value despite new input data.
        write_data = 8'h00;
        #1;
        if (read_data_b !== 8'h99)
            $fatal(1, "disabled write changed register: got %h", read_data_b);

        $display("PASS: register_file");
        $finish;
    end
endmodule
