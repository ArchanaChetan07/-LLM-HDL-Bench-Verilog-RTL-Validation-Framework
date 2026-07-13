module sequence_detector_1011(
    input clk,
    input rst,
    input din,
    output reg detected
);
    reg [2:0] state;
    localparam S0=0, S1=1, S10=2, S101=3, S1011=4;

    always @(posedge clk) begin
        if (rst) begin
            state <= S0;
            detected <= 0;
        end else begin
            detected <= 0;
            case (state)
                S0:   state <= din ? S1 : S0;
                S1:   state <= din ? S1 : S10;
                S10:  state <= din ? S101 : S0;
                S101: state <= din ? S1011 : S10;   // FIX (v2): mismatch after partial match
                                                     // must fall back to S10 (the "10" prefix
                                                     // just seen is still a valid partial match
                                                     // for a NEW overlapping sequence), not all
                                                     // the way to S0. v1 lost overlapping matches.
                S1011: begin
                    detected <= 1;
                    state <= din ? S1 : S10;         // FIX (v2): same reasoning -- on din=0 the
                                                      // last two bits seen ("...0") aren't a
                                                      // restart, they're "10" waiting for "11";
                                                      // actually last bit is 0 alone -> but the
                                                      // bit before din here was the 4th "1" of
                                                      // 1011, so seeing din=0 next means we've
                                                      // seen "...10", i.e. state S10, not S0.
                end
                default: state <= S0;
            endcase
        end
    end
endmodule
