`timescale 1ns/1ps

module tb_mux2;
    localparam int WIDTH = 8;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic             select;
    logic [WIDTH-1:0] y;

    mux2 #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .select(select),
        .y(y)
    );

    initial begin
        a = 8'h3C;
        b = 8'hA5;

        select = 1'b0;
        #1;
        if (y !== a) $fatal(1, "MUX should select input a");

        select = 1'b1;
        #1;
        if (y !== b) $fatal(1, "MUX should select input b");

        $display("PASS: mux2");
        $finish;
    end
endmodule

