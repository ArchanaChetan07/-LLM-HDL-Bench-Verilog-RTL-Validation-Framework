`timescale 1ns/1ps
module tb_sequence_detector_1011;
    reg clk=0, rst, din;
    wire detected;
    integer errors=0, i;

    // Reference software model of the Moore FSM, run in lockstep with the DUT
    // so we can generate long random-ish sequences and still know ground truth,
    // instead of relying on a single hand-picked short vector (the v1-pilot gap).
    reg [2:0] model_state;
    reg model_detected;
    localparam S0=0,S1=1,S10=2,S101=3,S1011=4;

    sequence_detector_1011 dut(.clk(clk), .rst(rst), .din(din), .detected(detected));
    always #5 clk = ~clk;

    task step(input bit_in);
        reg [2:0] next_state;
        reg next_detected;
        begin
            din = bit_in;
            // compute expected next state/output per the CORRECT Moore FSM
            // (must return to S10 on mismatch after S101, and to S10/S1 correctly
            // from S1011, to detect overlapping matches -- this is exactly the
            // class of bug the v1-pilot generated module had and v1's short,
            // non-overlapping test vector failed to catch)
            next_detected = 0;
            case (model_state)
                S0:    next_state = bit_in ? S1  : S0;
                S1:    next_state = bit_in ? S1  : S10;
                S10:   next_state = bit_in ? S101: S0;
                S101:  next_state = bit_in ? S1011 : S10;
                S1011: begin next_detected = 1; next_state = bit_in ? S1 : S10; end
                default: next_state = S0;
            endcase
            @(posedge clk); #1;
            model_state = next_state;
            model_detected = next_detected;
            if (detected !== model_detected) begin
                errors = errors + 1;
                $display("MISMATCH bit=%b detected=%b expected=%b (model_state now=%0d)", bit_in, detected, model_detected, model_state);
            end
        end
    endtask

    initial begin
        rst = 1; din = 0; @(posedge clk); #1;
        model_state = S0; model_detected = 0;
        rst = 0;

        // Test 1: original v1 vector (single match, no overlap stress)
        step(1); step(0); step(1); step(1); step(0); step(1); step(1);

        // Test 2: reset, then a genuinely overlapping double match: 1011011
        // (bits: 1,0,1,1,0,1,1 -- contains 1011 at position 0 AND position 3)
        rst = 1; @(posedge clk); #1; rst = 0; model_state = S0; model_detected = 0;
        step(1); step(0); step(1); step(1); step(0); step(1); step(1);
        step(1); // one more bit to let the second match's detected pulse land

        // Test 3: reset, then a mismatch-after-partial-match recovery case: 10100 1011
        // exercises "S101 sees a 0 -> must go to S10, not S0" (the exact v1 bug)
        rst = 1; @(posedge clk); #1; rst = 0; model_state = S0; model_detected = 0;
        step(1); step(0); step(1); step(0); step(0); step(1); step(0); step(1); step(1);

        // Test 4: long pseudo-random sequence, lockstep-checked against the model,
        // to catch anything the hand-picked vectors above still miss
        for (i = 0; i < 40; i = i + 1) begin
            step($random % 2);
        end

        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
