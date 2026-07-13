module sync_fifo_8x8(
    input clk,
    input rst,
    input wr_en,
    input  [7:0] wdata,
    input rd_en,
    output [7:0] rdata,
    output full,
    output empty
);
    reg [7:0] mem [0:7];
    reg [2:0] wptr, rptr;
    reg [3:0] count;

    always @(posedge clk) begin
        if (rst) begin
            wptr <= 0;
            rptr <= 0;
            count <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[wptr] <= wdata;
                wptr <= wptr + 1;
            end
            if (rd_en && !empty) begin
                rptr <= rptr + 1;
            end
            if ((wr_en && !full) && !(rd_en && !empty))
                count <= count + 1;
            else if (!(wr_en && !full) && (rd_en && !empty))
                count <= count - 1;
        end
    end

    assign rdata = mem[rptr];
    assign full = (count == 4'd8);
    assign empty = (count == 4'd0);
endmodule
