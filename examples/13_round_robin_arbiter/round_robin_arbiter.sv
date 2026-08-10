module round_robin_arbiter (
    input  logic       clk,
    input  logic       reset,
    input  logic [3:0] request,
    output logic [3:0] grant
);
    logic [1:0] next_index;

    // Start searching at next_index so repeated requests share access fairly.
    always_comb begin
        grant = 4'b0000;

        case (next_index)
            2'd0: begin
                if (request[0])      grant = 4'b0001;
                else if (request[1]) grant = 4'b0010;
                else if (request[2]) grant = 4'b0100;
                else if (request[3]) grant = 4'b1000;
            end
            2'd1: begin
                if (request[1])      grant = 4'b0010;
                else if (request[2]) grant = 4'b0100;
                else if (request[3]) grant = 4'b1000;
                else if (request[0]) grant = 4'b0001;
            end
            2'd2: begin
                if (request[2])      grant = 4'b0100;
                else if (request[3]) grant = 4'b1000;
                else if (request[0]) grant = 4'b0001;
                else if (request[1]) grant = 4'b0010;
            end
            default: begin
                if (request[3])      grant = 4'b1000;
                else if (request[0]) grant = 4'b0001;
                else if (request[1]) grant = 4'b0010;
                else if (request[2]) grant = 4'b0100;
            end
        endcase
    end

    // After a grant, begin the next search with the following requester.
    always_ff @(posedge clk) begin
        if (reset)
            next_index <= 2'd0;
        else if (grant[0])
            next_index <= 2'd1;
        else if (grant[1])
            next_index <= 2'd2;
        else if (grant[2])
            next_index <= 2'd3;
        else if (grant[3])
            next_index <= 2'd0;
    end
endmodule
