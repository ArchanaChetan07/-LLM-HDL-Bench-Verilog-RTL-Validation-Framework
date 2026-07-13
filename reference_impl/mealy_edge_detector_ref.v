module mealy_edge_detector(input clk, input rst, input din, output pulse);
    reg prev_din;
    always @(posedge clk) begin
        if (rst) prev_din <= 0;
        else prev_din <= din;
    end
    assign pulse = prev_din & ~din;
endmodule
