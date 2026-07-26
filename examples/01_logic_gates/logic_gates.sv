module logic_gates (
    input  logic a,
    input  logic b,
    output logic and_y,
    output logic or_y,
    output logic xor_y,
    output logic not_a
);
    assign and_y = a & b;
    assign or_y  = a | b;
    assign xor_y = a ^ b;
    assign not_a = ~a;
endmodule

