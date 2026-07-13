`timescale 1ns/1ps
module tb_circular_buffer_pointer_8x8;
    reg clk=0, rst, wr_en, rd_en; reg [7:0] wdata;
    wire [7:0] rdata; wire empty;
    reg [7:0] model_mem [0:7];
    integer wptr, rptr, count;
    integer i, errors=0;
    circular_buffer_pointer_8x8 dut(.clk(clk), .rst(rst), .wr_en(wr_en), .wdata(wdata),
                                     .rd_en(rd_en), .rdata(rdata), .empty(empty));
    always #5 clk=~clk;
    task step(input w, input [7:0] wd, input r); 
        reg do_read, rptr_advance;
        begin
            wr_en=w; wdata=wd; rd_en=r;
            do_read = r && (count!=0);
            rptr_advance = do_read || (w && (count==8));
            if (do_read && rdata !== model_mem[rptr]) begin
                errors=errors+1;
                $display("MISMATCH pre-edge rdata=%b expected=%b count=%0d rptr=%0d", rdata, model_mem[rptr], count, rptr);
            end
            @(posedge clk); #1;
            if (w) begin model_mem[wptr]=wd; wptr=(wptr+1)%8; end
            if (rptr_advance) rptr=(rptr+1)%8;
            count = count + (w?1:0) - (rptr_advance?1:0);
            if (empty !== (count==0)) begin
                errors=errors+1;
                $display("MISMATCH empty=%b expected=%b count=%0d", empty, (count==0), count);
            end
        end
    endtask
    initial begin
        errors=0; wptr=0; rptr=0; count=0;
        rst=1; wr_en=0; rd_en=0; wdata=0; @(posedge clk); #1;
        if (empty!==1) begin errors=errors+1; $display("MISMATCH not empty after reset"); end
        rst=0;
        // fill completely (8 writes)
        for (i=0;i<8;i=i+1) step(1, i[7:0]+8'h30, 0);
        // overwrite while full (no read) -- oldest silently dropped
        for (i=0;i<3;i=i+1) step(1, i[7:0]+8'h50, 0);
        // drain fully
        for (i=0;i<8;i=i+1) step(0, 0, 1);
        // extra read while empty -- must be ignored, no error
        step(0,0,1);
        // simultaneous write+read while full
        for (i=0;i<8;i=i+1) step(1, i[7:0]+8'h70, 0); // fill again
        for (i=0;i<5;i=i+1) step(1, i[7:0]+8'h90, 1); // push+pop while full, several times
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
