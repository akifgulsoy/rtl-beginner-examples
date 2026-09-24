`timescale 1ns/1ps

module tb_valid_ready_register;
    logic clk = 1'b0;
    logic reset;
    logic in_valid;
    logic in_ready;
    logic [3:0] in_data;
    logic out_valid;
    logic out_ready;
    logic [3:0] out_data;

    valid_ready_register #(.WIDTH(4)) dut (
        .clk(clk),
        .reset(reset),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_data(in_data),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_data(out_data)
    );

    always #5 clk = ~clk;

    task automatic check_outputs(
        input logic expected_in_ready,
        input logic expected_out_valid,
        input logic [3:0] expected_out_data
    );
        if (in_ready !== expected_in_ready ||
            out_valid !== expected_out_valid ||
            out_data !== expected_out_data)
            $fatal(1, "expected in_ready=%b out_valid=%b out_data=%h; got %b %b %h",
                   expected_in_ready, expected_out_valid, expected_out_data,
                   in_ready, out_valid, out_data);
    endtask

    initial begin
        reset = 1'b1;
        in_valid = 1'b0;
        in_data = '0;
        out_ready = 1'b0;

        @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, 4'h0);

        reset = 1'b0;
        // Store a word while the downstream receiver is stalled.
        in_valid = 1'b1;
        in_data = 4'ha;
        @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b1, 4'ha);

        // A full register holds its data until the receiver is ready.
        in_data = 4'h5;
        @(posedge clk);
        #1;
        check_outputs(1'b0, 1'b1, 4'ha);

        // Consume A and replace it with 5 in the same clock cycle.
        out_ready = 1'b1;
        @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b1, 4'h5);

        // With no new input, the accepted output makes the register empty.
        in_valid = 1'b0;
        @(posedge clk);
        #1;
        check_outputs(1'b1, 1'b0, 4'h5);

        $display("PASS: valid-ready register");
        $finish;
    end
endmodule
