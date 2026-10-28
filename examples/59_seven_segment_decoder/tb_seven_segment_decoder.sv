`timescale 1ns/1ps

module tb_seven_segment_decoder;
    logic [3:0] bcd;
    logic [6:0] segments;
    logic [6:0] expected_segments;
    integer     value;

    seven_segment_decoder dut (
        .bcd(bcd),
        .segments(segments)
    );

    function automatic logic [6:0] expected_for(input logic [3:0] digit);
        case (digit)
            4'd0:    expected_for = 7'b1111110;
            4'd1:    expected_for = 7'b0110000;
            4'd2:    expected_for = 7'b1101101;
            4'd3:    expected_for = 7'b1111001;
            4'd4:    expected_for = 7'b0110011;
            4'd5:    expected_for = 7'b1011011;
            4'd6:    expected_for = 7'b1011111;
            4'd7:    expected_for = 7'b1110000;
            4'd8:    expected_for = 7'b1111111;
            4'd9:    expected_for = 7'b1111011;
            default: expected_for = 7'b0000000;
        endcase
    endfunction

    initial begin
        // Check every four-bit input, including invalid BCD values.
        for (value = 0; value < 16; value = value + 1) begin
            bcd = value[3:0];
            expected_segments = expected_for(bcd);
            #1;

            if (segments !== expected_segments)
                $fatal(1, "BCD %0d: expected segments %b, got %b",
                       value, expected_segments, segments);
        end

        $display("PASS: seven_segment_decoder");
        $finish;
    end
endmodule
