module gray_counter4(
    input clk,
    input rst,
    output [3:0] gray_out
);
    reg [3:0] bin;

    always @(posedge clk) begin
        if (rst)
            bin <= 4'b0000;
        else
            bin <= bin + 1;
    end

    assign gray_out = bin ^ (bin >> 1);
endmodule
