module sync_fifo_8x8(input clk, input rst, input wr_en, input [7:0] wdata, input rd_en,
                      output [7:0] rdata, output full, output empty);
    reg [7:0] mem [0:7];
    reg [3:0] wptr, rptr;
    reg [3:0] count;
    always @(posedge clk) begin
        if (rst) begin wptr <= 0; rptr <= 0; count <= 0; end
        else begin
            if (wr_en && !full) begin mem[wptr[2:0]] <= wdata; wptr <= wptr + 1; end
            if (rd_en && !empty) begin rptr <= rptr + 1; end
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                default: count <= count;
            endcase
        end
    end
    assign rdata = mem[rptr[2:0]];
    assign full = (count == 8);
    assign empty = (count == 0);
endmodule
