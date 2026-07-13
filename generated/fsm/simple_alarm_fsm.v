module simple_alarm_fsm(
    input clk,
    input rst,
    input arm,
    input sensor,
    input disarm,
    output reg armed,
    output reg alarm_triggered
);
    localparam DISARMED = 2'd0, ARMED = 2'd1, TRIGGERED = 2'd2;
    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= DISARMED;
            armed <= 0;
            alarm_triggered <= 0;
        end else if (disarm) begin
            state <= DISARMED;
            armed <= 0;
            alarm_triggered <= 0;
        end else begin
            case (state)
                DISARMED: begin
                    if (arm) begin
                        state <= ARMED;
                        armed <= 1;
                    end
                end
                ARMED: begin
                    if (sensor) begin
                        state <= TRIGGERED;
                        alarm_triggered <= 1;
                    end
                end
                TRIGGERED: begin
                    alarm_triggered <= 1;
                end
                default: state <= DISARMED;
            endcase
        end
    end
endmodule
