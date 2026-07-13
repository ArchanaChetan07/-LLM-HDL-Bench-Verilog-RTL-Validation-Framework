module mod4_up_down_counter_fsm(input clk, input rst, input up_down, output reg [1:0] count);
    always @(posedge clk) begin
        if (rst) count<=0;
        else if (up_down) count<=count+1;
        else count<=count-1;
    end
endmodule
