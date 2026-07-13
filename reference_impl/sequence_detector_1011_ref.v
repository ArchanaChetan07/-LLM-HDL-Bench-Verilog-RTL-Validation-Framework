module sequence_detector_1011(input clk, input rst, input din, output reg detected);
    reg [2:0] state;
    localparam S0=0,S1=1,S10=2,S101=3,S1011=4;
    always @(posedge clk) begin
        if (rst) begin state <= S0; detected <= 0; end
        else begin
            detected <= 0;
            case (state)
                S0:    state <= din ? S1  : S0;
                S1:    state <= din ? S1  : S10;
                S10:   state <= din ? S101: S0;
                S101:  if (din) begin state <= S1011; end else state <= S10;
                S1011: begin detected <= 1; state <= din ? S1 : S10; end
                default: state <= S0;
            endcase
        end
    end
endmodule
