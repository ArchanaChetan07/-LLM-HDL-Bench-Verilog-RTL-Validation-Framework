module moore_edge_detector(
    input clk,
    input rst,
    input din,
    output reg pulse
);
    localparam IDLE=0, DETECTED=1, HIGH=2;
    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            pulse <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pulse <= 0;
                    if (din) state <= DETECTED;
                end
                DETECTED: begin
                    pulse <= 1;
                    state <= din ? HIGH : IDLE;
                end
                HIGH: begin
                    pulse <= 0;
                    if (!din) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
