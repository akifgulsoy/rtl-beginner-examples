`timescale 1ns/1ps

module tb_parallel_to_serial;
    logic clk = 1'b0;
    logic reset;
    logic load;
    logic shift_enable;
    logic [3:0] parallel_data;
    logic serial_out;

    parallel_to_serial #(.WIDTH(4)) dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .shift_enable(shift_enable),
        .parallel_data(parallel_data),
        .serial_out(serial_out)
    );

    always #5 clk = ~clk;

    task check_serial(input logic expected_bit);
        if (serial_out !== expected_bit)
            $fatal(1, "expected serial bit %b, got %b", expected_bit, serial_out);
    endtask

    initial begin
        reset = 1'b1;
        load = 1'b0;
        shift_enable = 1'b0;
        parallel_data = '0;

        @(posedge clk);
        #1;
        check_serial(1'b0);

        reset = 1'b0;
        load = 1'b1;
        parallel_data = 4'b1101;
        @(posedge clk);
        #1;
        // Loading makes bit 0 available immediately.
        check_serial(1'b1);

        load = 1'b0;
        shift_enable = 1'b1;
        @(posedge clk);
        #1;
        check_serial(1'b0);

        @(posedge clk);
        #1;
        check_serial(1'b1);

        @(posedge clk);
        #1;
        check_serial(1'b1);

        // Shifting zeros into the register empties it after WIDTH shifts.
        @(posedge clk);
        #1;
        check_serial(1'b0);

        // A disabled shifter holds the current serial output.
        shift_enable = 1'b0;
        @(posedge clk);
        #1;
        check_serial(1'b0);

        $display("PASS: parallel-to-serial register");
        $finish;
    end
endmodule
