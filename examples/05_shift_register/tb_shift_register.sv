`timescale 1ns/1ps

module tb_shift_register;
    localparam int WIDTH = 4;

    logic             clk = 1'b0;
    logic             rst;
    logic             enable;
    logic             serial_in;
    logic [WIDTH-1:0] parallel_out;

    shift_register #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    always #5 clk = ~clk;

    task automatic shift_bit(input logic value);
        @(negedge clk);
        serial_in = value;
        @(posedge clk);
        #1;
    endtask

    initial begin
        rst = 1'b1;
        enable = 1'b0;
        serial_in = 1'b0;
        @(posedge clk);
        #1;
        if (parallel_out !== '0) $fatal(1, "Reset failed");

        @(negedge clk);
        rst = 1'b0;
        enable = 1'b1;

        shift_bit(1'b1);
        shift_bit(1'b0);
        shift_bit(1'b1);
        shift_bit(1'b1);

        if (parallel_out !== 4'b1011)
            $fatal(1, "Expected 1011, got %b", parallel_out);

        $display("PASS: shift_register");
        $finish;
    end
endmodule

