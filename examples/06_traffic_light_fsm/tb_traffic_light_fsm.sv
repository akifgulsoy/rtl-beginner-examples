`timescale 1ns/1ps

module tb_traffic_light_fsm;
    logic clk = 1'b0;
    logic rst_n;
    logic advance;
    logic red;
    logic yellow;
    logic green;

    traffic_light_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .advance(advance),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    always #5 clk = ~clk;

    task automatic check_lights(
        input logic expected_red,
        input logic expected_yellow,
        input logic expected_green
    );
        #1;
        if ({red, yellow, green} !==
            {expected_red, expected_yellow, expected_green})
            $fatal(
                1,
                "Expected RYG=%b%b%b, got %b%b%b",
                expected_red,
                expected_yellow,
                expected_green,
                red,
                yellow,
                green
            );
    endtask

    task automatic move_to_next_state;
        @(negedge clk);
        advance = 1'b1;
        @(posedge clk);
        #1;
        advance = 1'b0;
    endtask

    initial begin
        rst_n = 1'b0;
        advance = 1'b0;
        check_lights(1'b1, 1'b0, 1'b0);

        @(negedge clk);
        rst_n = 1'b1;

        move_to_next_state();
        check_lights(1'b0, 1'b0, 1'b1);

        move_to_next_state();
        check_lights(1'b0, 1'b1, 1'b0);

        move_to_next_state();
        check_lights(1'b1, 1'b0, 1'b0);

        $display("PASS: traffic_light_fsm");
        $finish;
    end
endmodule

