module shadow_register_pair(
    input clk,
    input rst,
    input we,
    input  [7:0] wdata,
    input commit,
    input restore,
    output [7:0] working_out,
    output [7:0] shadow_out
);
    reg [7:0] working, shadow;

    always @(posedge clk) begin
        if (rst) begin
            working <= 8'b0;
            shadow <= 8'b0;
        end else if (restore) begin
            working <= shadow;
        end else if (commit) begin
            shadow <= working;
        end else if (we) begin
            working <= wdata;
        end
    end

    assign working_out = working;
    assign shadow_out = shadow;
endmodule
