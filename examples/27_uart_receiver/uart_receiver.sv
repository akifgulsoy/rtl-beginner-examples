module uart_receiver #(
    parameter int DATA_WIDTH = 8
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  baud_tick,
    input  logic                  serial_in,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  data_valid,
    output logic                  frame_error
);
    typedef enum logic [1:0] {IDLE, DATA, STOP} state_t;

    state_t state;
    logic [DATA_WIDTH-1:0] shift_reg;
    logic [$clog2(DATA_WIDTH)-1:0] bit_count;

    // baud_tick marks the sampling instant for each UART bit.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            shift_reg   <= '0;
            bit_count   <= '0;
            data_out    <= '0;
            data_valid  <= 1'b0;
            frame_error <= 1'b0;
        end else begin
            data_valid  <= 1'b0;
            frame_error <= 1'b0;

            if (baud_tick) begin
                case (state)
                    IDLE: begin
                        // A low level is the UART start bit.
                        if (!serial_in) begin
                            bit_count <= '0;
                            state     <= DATA;
                        end
                    end

                    DATA: begin
                        // UART sends the least-significant data bit first.
                        shift_reg[bit_count] <= serial_in;
                        if (bit_count == DATA_WIDTH - 1) begin
                            state <= STOP;
                        end else begin
                            bit_count <= bit_count + 1'b1;
                        end
                    end

                    STOP: begin
                        if (serial_in) begin
                            data_out   <= shift_reg;
                            data_valid <= 1'b1;
                        end else begin
                            frame_error <= 1'b1;
                        end
                        state <= IDLE;
                    end

                    default: state <= IDLE;
                endcase
            end
        end
    end
endmodule
