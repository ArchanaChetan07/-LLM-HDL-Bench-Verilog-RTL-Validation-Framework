module circular_buffer_pointer_8x8(input clk, input rst, input wr_en, input [7:0] wdata,
                                    input rd_en, output [7:0] rdata, output empty);
    reg [7:0] mem [0:7];
    reg [3:0] wptr, rptr, count;
    wire do_read = rd_en && !empty;
    // An entry leaves the queue either because it was read, or (if full) because an
    // incoming write overwrote the oldest slot -- these are the SAME slot/event when
    // both happen the same cycle (read sees the correct pre-overwrite value combinationally,
    // then the single oldest-entry departs), so rptr advances at most once per cycle.
    wire rptr_advance = do_read || (wr_en && (count == 8));

    always @(posedge clk) begin
        if (rst) begin
            wptr <= 0; rptr <= 0; count <= 0;
        end else begin
            if (wr_en) begin
                mem[wptr[2:0]] <= wdata;
                wptr <= wptr + 1;
            end
            if (rptr_advance)
                rptr <= rptr + 1;
            count <= count + (wr_en ? 1 : 0) - (rptr_advance ? 1 : 0);
        end
    end
    assign empty = (count == 0);
    assign rdata = mem[rptr[2:0]];
endmodule
