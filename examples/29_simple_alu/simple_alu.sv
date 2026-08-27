module simple_alu #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       operation,
    output logic [WIDTH-1:0] result,
    output logic             zero
);
    localparam logic [2:0] ADD = 3'd0;
    localparam logic [2:0] SUB = 3'd1;
    localparam logic [2:0] AND = 3'd2;
    localparam logic [2:0] OR  = 3'd3;
    localparam logic [2:0] XOR = 3'd4;
    localparam logic [2:0] SLL = 3'd5;
    localparam logic [2:0] SRL = 3'd6;

    // A case statement selects one combinational operation at a time.
    always_comb begin
        result = '0;

        case (operation)
            ADD: result = a + b;
            SUB: result = a - b;
            AND: result = a & b;
            OR:  result = a | b;
            XOR: result = a ^ b;
            SLL: result = a << b;
            SRL: result = a >> b;
            default: result = '0;
        endcase

        zero = (result == '0);
    end
endmodule
