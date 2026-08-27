`timescale 1ns/1ps

module tb_simple_alu;
    localparam int WIDTH = 4;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [2:0]       operation;
    logic [WIDTH-1:0] result;
    logic             zero;

    simple_alu #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .operation(operation),
        .result(result),
        .zero(zero)
    );

    task automatic check_operation(
        input logic [WIDTH-1:0] first,
        input logic [WIDTH-1:0] second,
        input logic [2:0]       selected_operation
    );
        logic [WIDTH-1:0] expected_result;
        logic             expected_zero;

        case (selected_operation)
            3'd0: expected_result = first + second;
            3'd1: expected_result = first - second;
            3'd2: expected_result = first & second;
            3'd3: expected_result = first | second;
            3'd4: expected_result = first ^ second;
            3'd5: expected_result = first << second;
            3'd6: expected_result = first >> second;
            default: expected_result = '0;
        endcase
        expected_zero = (expected_result == '0);

        a = first;
        b = second;
        operation = selected_operation;
        #1;

        if (result !== expected_result || zero !== expected_zero)
            $fatal(1, "a=%h b=%h operation=%0d: expected result=%h zero=%b, got result=%h zero=%b",
                   first, second, selected_operation, expected_result, expected_zero,
                   result, zero);
    endtask

    initial begin
        // Exercise every operation for all 4-bit operand pairs, including invalid opcode 7.
        for (int first = 0; first < 2**WIDTH; first++) begin
            for (int second = 0; second < 2**WIDTH; second++) begin
                for (int op = 0; op < 8; op++)
                    check_operation(first[WIDTH-1:0], second[WIDTH-1:0], op[2:0]);
            end
        end

        $display("PASS: simple_alu");
        $finish;
    end
endmodule
