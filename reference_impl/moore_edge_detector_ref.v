module moore_edge_detector(input clk, input rst, input din, output reg pulse);
    reg [1:0] state; // 0=idle_low,1=seen_rise(pulse),2=high_steady
    localparam LOW=0, PULSE=1, HIGH=2;
    always @(posedge clk) begin
        if (rst) begin state<=LOW; pulse<=0; end
        else begin
            case(state)
                LOW:   begin pulse<=0; if (din) state<=PULSE; end
                PULSE: begin pulse<=1; state<= din ? HIGH : LOW; end
                HIGH:  begin pulse<=0; if (!din) state<=LOW; end
                default: state<=LOW;
            endcase
        end
    end
endmodule
