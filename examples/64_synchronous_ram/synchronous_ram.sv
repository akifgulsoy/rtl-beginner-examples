module synchronous_ram #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 3
) (
    input  logic                  clk,
    input  logic                  enable,
    input  logic                  write_en,
    input  logic [ADDR_WIDTH-1:0] address,
    input  logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] read_data
);
    localparam int DEPTH = 1 << ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    // No reset: write a location before relying on its contents.
    always_ff @(posedge clk) begin
        if (enable) begin
            // Nonblocking assignments read the OLD word on a write cycle.
            read_data <= memory[address];
            if (write_en)
                memory[address] <= write_data;
        end
        // Without enable, both memory and the registered output hold.
    end
endmodule
