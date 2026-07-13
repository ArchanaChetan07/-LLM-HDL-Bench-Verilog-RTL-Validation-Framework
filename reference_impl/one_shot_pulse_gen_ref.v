module one_shot_pulse_gen(input clk, input rst, input trigger, output reg pulse_out);
    reg [1:0] cnt;
    reg active;
    always @(posedge clk) begin
        if (rst) begin pulse_out<=0; active<=0; cnt<=0; end
        else if (!active) begin
            if (trigger) begin active<=1; pulse_out<=1; cnt<=0; end
            else pulse_out<=0;
        end else begin
            if (cnt == 2) begin active<=0; pulse_out<=0; end
            else begin cnt<=cnt+1; pulse_out<=1; end
        end
    end
endmodule
