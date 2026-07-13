module lfsr8(input clk, input rst, output [7:0] value);
    reg [7:0] reg_val;
    wire fb = reg_val[7] ^ reg_val[5] ^ reg_val[4] ^ reg_val[3];
    always @(posedge clk) begin
        if (rst) reg_val <= 8'hFF;
        else reg_val <= {reg_val[6:0], fb};
    end
    assign value = reg_val;
endmodule
