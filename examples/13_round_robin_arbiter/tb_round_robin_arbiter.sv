`timescale 1ns/1ps

module tb_round_robin_arbiter;
    logic       clk = 1'b0;
    logic       reset;
    logic [3:0] request;
    logic [3:0] grant;

    round_robin_arbiter dut (
        .clk(clk),
        .reset(reset),
        .request(request),
        .grant(grant)
    );

    always #5 clk = ~clk;

    task automatic check_grant(input logic [3:0] expected_grant);
        #1;
        if (grant !== expected_grant)
            $fatal(1, "request=%b: expected grant=%b, got grant=%b",
                   request, expected_grant, grant);
    endtask

    initial begin
        reset = 1'b1;
        request = 4'b0000;
        @(posedge clk);
        #1;
        reset = 1'b0;

        // With no requests, nobody is granted and the search position stays put.
        check_grant(4'b0000);

        // Two persistent requesters alternate instead of one always winning.
        request = 4'b0101;
        check_grant(4'b0001);
        @(posedge clk);
        check_grant(4'b0100);
        @(posedge clk);
        check_grant(4'b0001);

        // Four requests rotate through each requester after a grant.
        request = 4'b1111;
        @(posedge clk);
        check_grant(4'b0001);
        @(posedge clk);
        check_grant(4'b0010);
        @(posedge clk);
        check_grant(4'b0100);
        @(posedge clk);
        check_grant(4'b1000);

        $display("PASS: round_robin_arbiter");
        $finish;
    end
endmodule
