module sync_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 2
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  write_en,
    input  logic [DATA_WIDTH-1:0] write_data,
    input  logic                  read_en,
    output logic [DATA_WIDTH-1:0] read_data,
    output logic                  full,
    output logic                  empty
);
    localparam int DEPTH = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    logic [ADDR_WIDTH-1:0] write_ptr;
    logic [ADDR_WIDTH-1:0] read_ptr;
    logic [ADDR_WIDTH:0]   count;

    // The occupancy count makes full and empty unambiguous when pointers match.
    assign empty = (count == 0);
    assign full  = (count == DEPTH);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= '0;
            read_ptr  <= '0;
            read_data <= '0;
            count     <= '0;
        end else begin
            case ({write_en && !full, read_en && !empty})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase

            if (write_en && !full) begin
                memory[write_ptr] <= write_data;
                write_ptr <= write_ptr + 1'b1;
            end

            if (read_en && !empty) begin
                read_data <= memory[read_ptr];
                read_ptr <= read_ptr + 1'b1;
            end
        end
    end
endmodule
