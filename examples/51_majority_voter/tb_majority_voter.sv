`timescale 1ns/1ps

module tb_majority_voter;
    logic [3:0] a, b, c;
    logic [3:0] vote;

    majority_voter #(.WIDTH(4)) dut (.a(a), .b(b), .c(c), .vote(vote));

    initial begin
        // Exhaust every combination on every bit in parallel.
        for (int i = 0; i < 8; i++) begin
            a = {4{i[2]}};
            b = {4{i[1]}};
            c = {4{i[0]}};
            #1;
            if (vote !== {4{((i >> 2) & 1) + ((i >> 1) & 1) + (i & 1) >= 2}})
                $fatal(1, "input combination %0d: unexpected vote %b", i, vote);
        end

        // Different values in each lane check that voting is bitwise.
        a = 4'b1100; b = 4'b1010; c = 4'b0110;
        #1;
        if (vote !== 4'b1110)
            $fatal(1, "mixed lanes: expected 1110, got %b", vote);

        $display("PASS: majority_voter");
        $finish;
    end
endmodule
