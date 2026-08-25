`timescale 1ns/1ps

module tb_uart_transmitter;
    logic clk = 1'b0;
    logic rst_n;
    logic baud_tick;
    logic start;
    logic [7:0] data;
    logic serial_out;
    logic busy;

    uart_transmitter #(.DATA_WIDTH(8)) dut (
        .clk(clk), .rst_n(rst_n), .baud_tick(baud_tick), .start(start),
        .data(data), .serial_out(serial_out), .busy(busy)
    );

    always #5 clk = ~clk;

    task automatic tick_and_expect(input logic expected_bit, input logic expected_busy);
        @(negedge clk);
        baud_tick = 1'b1;
        @(posedge clk);
        #1;
        if (serial_out !== expected_bit || busy !== expected_busy)
            $fatal(1, "expected serial_out=%b busy=%b, got serial_out=%b busy=%b",
                   expected_bit, expected_busy, serial_out, busy);
        @(negedge clk);
        baud_tick = 1'b0;
    endtask

    initial begin
        rst_n = 1'b0;
        baud_tick = 1'b0;
        start = 1'b0;
        data = '0;
        #1;
        if (serial_out !== 1'b1 || busy !== 1'b0)
            $fatal(1, "reset must leave the UART idle");

        @(negedge clk);
        rst_n = 1'b1;
        start = 1'b1;
        data = 8'hA5;
        @(posedge clk);
        #1;
        if (serial_out !== 1'b0 || busy !== 1'b1)
            $fatal(1, "accepted data must begin with a start bit");
        @(negedge clk);
        start = 1'b0;

        // 8'hA5 is sent least-significant bit first: 1,0,1,0,0,1,0,1.
        tick_and_expect(1'b1, 1'b1);
        tick_and_expect(1'b0, 1'b1);

        // A request while busy must not replace the frame already in progress.
        @(negedge clk);
        start = 1'b1;
        data = 8'h00;
        @(posedge clk);
        #1;
        if (serial_out !== 1'b0 || busy !== 1'b1)
            $fatal(1, "a busy UART must ignore a new start request");
        @(negedge clk);
        start = 1'b0;

        tick_and_expect(1'b1, 1'b1);
        tick_and_expect(1'b0, 1'b1);
        tick_and_expect(1'b0, 1'b1);
        tick_and_expect(1'b1, 1'b1);
        tick_and_expect(1'b0, 1'b1);
        tick_and_expect(1'b1, 1'b1);
        tick_and_expect(1'b1, 1'b1); // Stop bit.
        tick_and_expect(1'b1, 1'b0); // Return to the idle-high state.

        $display("PASS: uart_transmitter");
        $finish;
    end
endmodule
