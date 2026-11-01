module spi_mode0_receiver #(
    parameter int DATA_WIDTH = 8
) (
    input  logic                  rst_n,
    input  logic                  sclk,
    input  logic                  cs_n,
    input  logic                  mosi,
    output logic [DATA_WIDTH-1:0] data,
    output logic                  data_valid
);
    logic [$clog2(DATA_WIDTH)-1:0] bit_count;
    logic [DATA_WIDTH-1:0] shift_reg;

    // SPI mode 0 samples MOSI on rising SCLK edges while the slave is selected.
    always_ff @(posedge sclk or negedge rst_n or posedge cs_n) begin
        if (!rst_n) begin
            bit_count  <= '0;
            shift_reg  <= '0;
            data       <= '0;
            data_valid <= 1'b0;
        end else if (cs_n) begin
            bit_count  <= '0;
            data_valid <= 1'b0;
        end else begin
            data_valid <= 1'b0;
            shift_reg  <= {shift_reg[DATA_WIDTH-2:0], mosi};

            if (bit_count == DATA_WIDTH - 1) begin
                data       <= {shift_reg[DATA_WIDTH-2:0], mosi};
                data_valid <= 1'b1;
                bit_count  <= '0;
            end else begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end
endmodule
