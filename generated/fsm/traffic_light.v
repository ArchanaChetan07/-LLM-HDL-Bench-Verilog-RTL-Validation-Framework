module traffic_light(
    input clk,
    input rst,
    output reg [1:0] light
);
    reg [3:0] cnt;
    localparam RED=2'b00, GREEN=2'b01, YELLOW=2'b10;

    always @(posedge clk) begin
        if (rst) begin
            light <= RED;
            cnt <= 4'd0;
        end else begin
            case (light)
                RED: begin
                    if (cnt == 4'd3) begin light <= GREEN; cnt <= 0; end
                    else cnt <= cnt + 1;
                end
                GREEN: begin
                    if (cnt == 4'd3) begin light <= YELLOW; cnt <= 0; end
                    else cnt <= cnt + 1;
                end
                YELLOW: begin
                    if (cnt == 4'd1) begin light <= RED; cnt <= 0; end
                    else cnt <= cnt + 1;
                end
                default: begin light <= RED; cnt <= 0; end
            endcase
        end
    end
endmodule
