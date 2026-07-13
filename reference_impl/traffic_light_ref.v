module traffic_light(input clk, input rst, output reg [1:0] light);
    reg [3:0] cnt;
    localparam RED=2'b00, GREEN=2'b01, YELLOW=2'b10;
    always @(posedge clk) begin
        if (rst) begin light <= RED; cnt <= 0; end
        else begin
            case (light)
                GREEN: if (cnt == 3) begin light <= YELLOW; cnt <= 0; end else cnt <= cnt + 1;
                YELLOW: if (cnt == 1) begin light <= RED; cnt <= 0; end else cnt <= cnt + 1;
                RED: if (cnt == 3) begin light <= GREEN; cnt <= 0; end else cnt <= cnt + 1;
                default: begin light <= RED; cnt <= 0; end
            endcase
        end
    end
endmodule
