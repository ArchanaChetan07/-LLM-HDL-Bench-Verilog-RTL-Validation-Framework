module one_shot_pulse_gen(
    input clk,
    input rst,
    input trigger,
    output reg pulse_out
);
    reg [1:0] cnt;
    reg busy;

    always @(posedge clk) begin
        if (rst) begin
            pulse_out <= 0;
            busy <= 0;
            cnt <= 0;
        end else if (!busy) begin
            if (trigger) begin
                busy <= 1;
                pulse_out <= 1;
                cnt <= 1;
            end else begin
                pulse_out <= 0;
            end
        end else begin
            if (cnt == 3) begin
                busy <= 0;
                pulse_out <= 0;
            end else begin
                cnt <= cnt + 1;
                pulse_out <= 1;
            end
        end
    end
endmodule
