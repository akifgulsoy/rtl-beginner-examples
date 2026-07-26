module traffic_light_fsm (
    input  logic clk,
    input  logic rst_n,
    input  logic advance,
    output logic red,
    output logic yellow,
    output logic green
);
    typedef enum logic [1:0] {
        RED_STATE,
        GREEN_STATE,
        YELLOW_STATE
    } state_t;

    state_t state;
    state_t next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= RED_STATE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;

        if (advance) begin
            case (state)
                RED_STATE:    next_state = GREEN_STATE;
                GREEN_STATE:  next_state = YELLOW_STATE;
                YELLOW_STATE: next_state = RED_STATE;
                default:      next_state = RED_STATE;
            endcase
        end
    end

    always_comb begin
        red = 1'b0;
        yellow = 1'b0;
        green = 1'b0;

        case (state)
            RED_STATE:    red = 1'b1;
            GREEN_STATE:  green = 1'b1;
            YELLOW_STATE: yellow = 1'b1;
            default:      red = 1'b1;
        endcase
    end
endmodule

