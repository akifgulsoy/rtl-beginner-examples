module priority_encoder (
    input  logic [3:0] request,
    output logic       valid,
    output logic [1:0] index
);
    // Bit 3 has the highest priority and bit 0 has the lowest.
    always_comb begin
        valid = 1'b1;

        if (request[3])
            index = 2'd3;
        else if (request[2])
            index = 2'd2;
        else if (request[1])
            index = 2'd1;
        else if (request[0])
            index = 2'd0;
        else begin
            valid = 1'b0;
            index = 2'd0;
        end
    end
endmodule
