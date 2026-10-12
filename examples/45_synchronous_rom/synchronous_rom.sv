module synchronous_rom (
    input  logic       clk,
    input  logic [1:0] address,
    output logic [7:0] read_data
);
    // Registering the read data makes this a one-clock-latency ROM.
    always_ff @(posedge clk) begin
        case (address)
            2'd0:    read_data <= 8'h3c;
            2'd1:    read_data <= 8'ha5;
            2'd2:    read_data <= 8'h5a;
            default: read_data <= 8'hc3;
        endcase
    end
endmodule
