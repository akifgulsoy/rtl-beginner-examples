module mux2 #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             select,
    output logic [WIDTH-1:0] y
);
    assign y = select ? b : a;
endmodule

