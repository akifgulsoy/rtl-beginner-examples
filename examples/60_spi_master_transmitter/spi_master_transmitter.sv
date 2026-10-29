module spi_master_transmitter #(
    parameter int DATA_WIDTH = 8
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  spi_tick,
    input  logic                  start,
    input  logic [DATA_WIDTH-1:0] data,
    output logic                  sclk,
    output logic                  mosi,
    output logic                  cs_n,
    output logic                  busy
);
    logic [DATA_WIDTH-1:0] shift_reg;
    logic [$clog2(DATA_WIDTH)-1:0] bit_count;

    // SPI mode 0 changes MOSI on falling edges and the receiver samples on rising edges.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= '0;
            bit_count <= '0;
            sclk      <= 1'b0;
            mosi      <= 1'b0;
            cs_n      <= 1'b1;
            busy      <= 1'b0;
        end else if (start && !busy) begin
            shift_reg <= data;
            bit_count <= '0;
            sclk      <= 1'b0;
            mosi      <= data[DATA_WIDTH-1];
            cs_n      <= 1'b0;
            busy      <= 1'b1;
        end else if (busy && spi_tick) begin
            if (!sclk) begin
                // Rising edge: keep the current data bit stable for sampling.
                sclk <= 1'b1;
            end else begin
                // Falling edge: either prepare the next bit or finish the transfer.
                sclk <= 1'b0;
                if (bit_count == DATA_WIDTH - 1) begin
                    cs_n <= 1'b1;
                    busy <= 1'b0;
                end else begin
                    shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
                    mosi      <= shift_reg[DATA_WIDTH-2];
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end
endmodule
