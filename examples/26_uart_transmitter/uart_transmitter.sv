module uart_transmitter #(
    parameter int DATA_WIDTH = 8
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  baud_tick,
    input  logic                  start,
    input  logic [DATA_WIDTH-1:0] data,
    output logic                  serial_out,
    output logic                  busy
);
    localparam int FRAME_BITS = DATA_WIDTH + 2;

    logic [FRAME_BITS-1:0] shift_reg;
    logic [$clog2(FRAME_BITS)-1:0] bit_count;

    // A UART frame is idle-high, then a start bit, data LSB first, and a stop bit.
    assign serial_out = busy ? shift_reg[0] : 1'b1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= '0;
            bit_count <= '0;
            busy      <= 1'b0;
        end else if (start && !busy) begin
            shift_reg <= {1'b1, data, 1'b0};
            bit_count <= '0;
            busy      <= 1'b1;
        end else if (busy && baud_tick) begin
            if (bit_count == FRAME_BITS - 1) begin
                bit_count <= '0;
                busy      <= 1'b0;
            end else begin
                shift_reg <= {1'b1, shift_reg[FRAME_BITS-1:1]};
                bit_count <= bit_count + 1'b1;
            end
        end
    end
endmodule
