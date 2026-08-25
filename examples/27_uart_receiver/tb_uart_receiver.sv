`timescale 1ns/1ps

module tb_uart_receiver;
    logic clk = 1'b0;
    logic rst_n;
    logic baud_tick;
    logic serial_in;
    logic [7:0] data_out;
    logic data_valid;
    logic frame_error;

    uart_receiver #(.DATA_WIDTH(8)) dut (
        .clk(clk), .rst_n(rst_n), .baud_tick(baud_tick), .serial_in(serial_in),
        .data_out(data_out), .data_valid(data_valid), .frame_error(frame_error)
    );

    always #5 clk = ~clk;

    task automatic send_bit(input logic bit_value);
        @(negedge clk);
        serial_in = bit_value;
        baud_tick = 1'b1;
        @(negedge clk);
        baud_tick = 1'b0;
    endtask

    task automatic send_frame(input logic [7:0] value, input logic stop_bit);
        int bit_index;
        begin
            send_bit(1'b0);
            for (bit_index = 0; bit_index < 8; bit_index++)
                send_bit(value[bit_index]);
            send_bit(stop_bit);
        end
    endtask

    initial begin
        rst_n = 1'b0;
        baud_tick = 1'b0;
        serial_in = 1'b1;
        #1;
        if (data_valid !== 1'b0 || frame_error !== 1'b0)
            $fatal(1, "reset must clear status pulses");

        @(negedge clk);
        rst_n = 1'b1;

        // 8'hA5 arrives least-significant bit first.
        send_frame(8'hA5, 1'b1);
        #1;
        if (data_out !== 8'hA5 || data_valid !== 1'b1 || frame_error !== 1'b0)
            $fatal(1, "valid frame was not received correctly");

        @(posedge clk);
        #1;
        if (data_valid !== 1'b0)
            $fatal(1, "data_valid must be a one-clock pulse");

        send_frame(8'h3C, 1'b0);
        #1;
        if (data_out !== 8'hA5 || data_valid !== 1'b0 || frame_error !== 1'b1)
            $fatal(1, "bad stop bit must report an error without replacing data");

        @(posedge clk);
        #1;
        if (frame_error !== 1'b0)
            $fatal(1, "frame_error must be a one-clock pulse");

        $display("PASS: uart_receiver");
        $finish;
    end
endmodule
