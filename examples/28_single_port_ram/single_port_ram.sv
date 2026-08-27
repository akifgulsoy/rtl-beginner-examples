module single_port_ram #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 3
) (
    input  logic                  clk,
    input  logic                  write_en,
    input  logic [ADDR_WIDTH-1:0] address,
    input  logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] read_data
);
    localparam int DEPTH = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    // Writes occur only on a clock edge when write_en is asserted.
    always_ff @(posedge clk) begin
        if (write_en)
            memory[address] <= write_data;
    end

    // The currently addressed word is available without waiting for a clock.
    assign read_data = memory[address];
endmodule
