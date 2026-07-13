module walking_1_pattern(
    input clk,
    input rst,
    output reg [3:0] pattern
);
    always @(posedge clk) begin
        if (rst)
            pattern <= 4'b0001;
        else
            pattern <= {pattern[2:0], pattern[3]};
    end
endmodule
