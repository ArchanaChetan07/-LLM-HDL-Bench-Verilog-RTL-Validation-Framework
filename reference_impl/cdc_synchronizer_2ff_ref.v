module cdc_synchronizer_2ff(input clk, input rst, input async_in, output sync_out);
    reg ff1, ff2;
    always @(posedge clk) begin
        if (rst) begin ff1<=0; ff2<=0; end
        else begin ff1<=async_in; ff2<=ff1; end
    end
    assign sync_out = ff2;
endmodule
