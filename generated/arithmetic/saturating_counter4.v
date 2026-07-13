module saturating_counter4(
    input clk,
    input rst,
    input en,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (rst)
            count <= 4'b0000;
        else if (en && count != 4'b1111)
            count <= count + 1;
    end
endmodule
