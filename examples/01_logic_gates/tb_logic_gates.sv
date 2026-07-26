`timescale 1ns/1ps

module tb_logic_gates;
    logic a;
    logic b;
    logic and_y;
    logic or_y;
    logic xor_y;
    logic not_a;

    logic_gates dut (
        .a(a),
        .b(b),
        .and_y(and_y),
        .or_y(or_y),
        .xor_y(xor_y),
        .not_a(not_a)
    );

    initial begin
        for (int value = 0; value < 4; value++) begin
            {a, b} = value[1:0];
            #1;

            if (and_y !== (a & b)) $fatal(1, "AND failed for a=%0b b=%0b", a, b);
            if (or_y  !== (a | b)) $fatal(1, "OR failed for a=%0b b=%0b", a, b);
            if (xor_y !== (a ^ b)) $fatal(1, "XOR failed for a=%0b b=%0b", a, b);
            if (not_a !== ~a)      $fatal(1, "NOT failed for a=%0b", a);
        end

        $display("PASS: logic_gates");
        $finish;
    end
endmodule

