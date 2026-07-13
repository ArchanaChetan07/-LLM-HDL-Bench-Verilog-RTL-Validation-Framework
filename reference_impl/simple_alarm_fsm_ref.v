module simple_alarm_fsm(input clk, input rst, input arm, input sensor, input disarm,
                         output reg armed, output reg alarm_triggered);
    localparam DISARMED=0, ARMED=1, TRIGGERED=2;
    reg [1:0] state;
    always @(posedge clk) begin
        if (rst) begin state<=DISARMED; armed<=0; alarm_triggered<=0; end
        else if (disarm) begin state<=DISARMED; armed<=0; alarm_triggered<=0; end
        else begin
            case(state)
                DISARMED: if (arm) begin state<=ARMED; armed<=1; end
                ARMED: begin armed<=1; if (sensor) begin state<=TRIGGERED; alarm_triggered<=1; end end
                TRIGGERED: begin armed<=1; alarm_triggered<=1; end
                default: state<=DISARMED;
            endcase
        end
    end
endmodule
