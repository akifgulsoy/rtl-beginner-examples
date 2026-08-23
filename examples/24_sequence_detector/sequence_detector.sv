module sequence_detector (
    input  logic clk,
    input  logic rst_n,
    input  logic bit_in,
    output logic detected
);
    // Moore states remember the longest suffix that is also a prefix of 1011.
    typedef enum logic [2:0] {
        IDLE,
        GOT_1,
        GOT_10,
        GOT_101,
        GOT_1011
    } state_t;

    state_t state;
    state_t next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE: begin
                if (bit_in)
                    next_state = GOT_1;
                else
                    next_state = IDLE;
            end
            GOT_1: begin
                if (bit_in)
                    next_state = GOT_1;
                else
                    next_state = GOT_10;
            end
            GOT_10: begin
                if (bit_in)
                    next_state = GOT_101;
                else
                    next_state = IDLE;
            end
            GOT_101: begin
                if (bit_in)
                    next_state = GOT_1011;
                else
                    next_state = GOT_10;
            end
            // Keep the final 1 so 1011011 detects two overlapping matches.
            GOT_1011: begin
                if (bit_in)
                    next_state = GOT_1;
                else
                    next_state = GOT_10;
            end
            default:  next_state = IDLE;
        endcase
    end

    assign detected = (state == GOT_1011);
endmodule
