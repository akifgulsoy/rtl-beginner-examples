module register_file #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 3
) (
    input  logic                  clk,
    input  logic                  write_en,
    input  logic [ADDR_WIDTH-1:0] write_address,
    input  logic [DATA_WIDTH-1:0] write_data,
    input  logic [ADDR_WIDTH-1:0] read_address_a,
    input  logic [ADDR_WIDTH-1:0] read_address_b,
    output logic [DATA_WIDTH-1:0] read_data_a,
    output logic [DATA_WIDTH-1:0] read_data_b
);
    localparam int DEPTH = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] registers [0:DEPTH-1];

    // One selected register changes only on a clock edge.
    always_ff @(posedge clk) begin
        if (write_en)
            registers[write_address] <= write_data;
    end

    // Both read ports independently expose their selected words immediately.
    assign read_data_a = registers[read_address_a];
    assign read_data_b = registers[read_address_b];
endmodule
