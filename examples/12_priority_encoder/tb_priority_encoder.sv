`timescale 1ns/1ps

module tb_priority_encoder;
    logic [3:0] request;
    logic       valid;
    logic [1:0] index;

    priority_encoder dut (
        .request(request),
        .valid(valid),
        .index(index)
    );

    task automatic check(input logic [3:0] input_request,
                         input logic expected_valid,
                         input logic [1:0] expected_index);
        request = input_request;
        #1;

        if (valid !== expected_valid || index !== expected_index)
            $fatal(1, "request=%b: expected valid=%b index=%0d, got valid=%b index=%0d",
                   input_request, expected_valid, expected_index, valid, index);
    endtask

    initial begin
        // Check every possible request pattern, including simultaneous requests.
        for (int value = 0; value < 16; value++) begin
            if (value == 0)
                check(value[3:0], 1'b0, 2'd0);
            else if (value[3])
                check(value[3:0], 1'b1, 2'd3);
            else if (value[2])
                check(value[3:0], 1'b1, 2'd2);
            else if (value[1])
                check(value[3:0], 1'b1, 2'd1);
            else
                check(value[3:0], 1'b1, 2'd0);
        end

        $display("PASS: priority_encoder");
        $finish;
    end
endmodule
