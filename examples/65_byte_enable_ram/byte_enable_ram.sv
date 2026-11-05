module byte_enable_ram #(
    parameter int BYTE_COUNT = 2,
    parameter int ADDR_WIDTH = 3
) (
    input  logic                  clk,
    input  logic                  enable,
    input  logic [BYTE_COUNT-1:0]  byte_en,
    input  logic [ADDR_WIDTH-1:0]  address,
    input  logic [8*BYTE_COUNT-1:0] write_data,
    output logic [8*BYTE_COUNT-1:0] read_data
);
    localparam int DEPTH = 1 << ADDR_WIDTH;
    logic [8*BYTE_COUNT-1:0] memory [0:DEPTH-1];

    always_ff @(posedge clk) begin
        if (enable) begin
            // Capture the old word before applying any byte writes.
            read_data <= memory[address];
            for (int lane = 0; lane < BYTE_COUNT; lane++) begin
                if (byte_en[lane])
                    memory[address][8*lane +: 8] <= write_data[8*lane +: 8];
            end
        end
    end
endmodule
