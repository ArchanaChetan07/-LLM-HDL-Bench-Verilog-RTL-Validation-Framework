module shadow_register_pair(input clk, input rst, input we, input [7:0] wdata,
                             input commit, input restore,
                             output [7:0] working_out, output [7:0] shadow_out);
    reg [7:0] working, shadow;
    always @(posedge clk) begin
        if (rst) begin working<=0; shadow<=0; end
        else if (restore) working <= shadow;
        else if (commit) shadow <= working;
        else if (we) working <= wdata;
    end
    assign working_out = working;
    assign shadow_out = shadow;
endmodule
