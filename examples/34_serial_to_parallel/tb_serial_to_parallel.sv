`timescale 1ns/1ps

module tb_serial_to_parallel;
    logic clk = 1'b0;
    logic reset;
    logic shift_enable;
    logic serial_in;
    logic [3:0] parallel_data;

    serial_to_parallel #(.WIDTH(4)) dut (
        .clk(clk),
        .reset(reset),
        .shift_enable(shift_enable),
        .serial_in(serial_in),
        .parallel_data(parallel_data)
    );

    always #5 clk = ~clk;

    task check_data(input logic [3:0] expected_data);
        if (parallel_data !== expected_data)
            $fatal(1, "expected parallel data %b, got %b", expected_data, parallel_data);
    endtask

    initial begin
        reset = 1'b1;
        shift_enable = 1'b0;
        serial_in = 1'b0;

        @(posedge clk);
        #1;
        check_data(4'b0000);

        reset = 1'b0;
        shift_enable = 1'b1;

        // Shift 4'b1101 in least-significant-bit first.
        serial_in = 1'b1;
        @(posedge clk);
        #1;
        check_data(4'b1000);

        serial_in = 1'b0;
        @(posedge clk);
        #1;
        check_data(4'b0100);

        serial_in = 1'b1;
        @(posedge clk);
        #1;
        check_data(4'b1010);

        serial_in = 1'b1;
        @(posedge clk);
        #1;
        check_data(4'b1101);

        // A disabled shifter holds the completed parallel word.
        shift_enable = 1'b0;
        serial_in = 1'b0;
        @(posedge clk);
        #1;
        check_data(4'b1101);

        $display("PASS: serial-to-parallel register");
        $finish;
    end
endmodule
