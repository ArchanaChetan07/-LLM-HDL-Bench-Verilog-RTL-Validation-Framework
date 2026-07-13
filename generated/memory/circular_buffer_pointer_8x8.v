module circular_buffer_pointer_8x8(
    input clk,
    input rst,
    input wr_en,
    input  [7:0] wdata,
    input rd_en,
    output [7:0] rdata,
    output empty
);
    reg [7:0] mem [0:7];
    reg [3:0] wptr, rptr, count;

    always @(posedge clk) begin
        if (rst) begin
            wptr <= 0;
            rptr <= 0;
            count <= 0;
        end else begin
            if (wr_en) begin
                mem[wptr[2:0]] <= wdata;
                wptr <= wptr + 1;
                if (count == 8)
                    rptr <= rptr + 1;   // oldest overwritten
            end
            if (rd_en && count != 0) begin
                rptr <= rptr + 1;       // BUG: double-advances rptr when also overwriting full
            end

            if (wr_en && !(rd_en && count != 0) && count != 8)
                count <= count + 1;
            else if (!wr_en && rd_en && count != 0)
                count <= count - 1;
        end
    end

    assign empty = (count == 0);
    assign rdata = mem[rptr[2:0]];
endmodule
