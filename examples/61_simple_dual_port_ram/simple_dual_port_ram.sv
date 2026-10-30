module simple_dual_port_ram #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 3
) (
    input  logic                  clk,
    input  logic                  write_en,
    input  logic [ADDR_WIDTH-1:0] write_address,
    input  logic [DATA_WIDTH-1:0] write_data,
    input  logic [ADDR_WIDTH-1:0] read_address,
    output logic [DATA_WIDTH-1:0] read_data
);
    localparam int DEPTH = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    // This port changes memory only on a clock edge.
    always_ff @(posedge clk) begin
        if (write_en)
            memory[write_address] <= write_data;
    end

    // A different address can be read while the write port updates memory.
    assign read_data = memory[read_address];
endmodule
