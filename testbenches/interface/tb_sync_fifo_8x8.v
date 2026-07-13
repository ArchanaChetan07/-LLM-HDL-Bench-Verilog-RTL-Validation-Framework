`timescale 1ns/1ps
module tb_sync_fifo_8x8;
    reg clk=0, rst, wr_en, rd_en; reg [7:0] wdata;
    wire [7:0] rdata; wire full, empty;
    reg [7:0] model_q [0:31]; integer head, tail, count;
    integer i, errors=0;
    sync_fifo_8x8 dut(.clk(clk), .rst(rst), .wr_en(wr_en), .wdata(wdata), .rd_en(rd_en),
                       .rdata(rdata), .full(full), .empty(empty));
    always #5 clk=~clk;
    task check_flags(input [127:0] msg);
        begin
            if (full !== (count==8) || empty !== (count==0)) begin
                errors=errors+1;
                $display("MISMATCH %0s full=%b(exp %0d) empty=%b(exp %0d) count=%0d", msg, full, (count==8), empty, (count==0), count);
            end
        end
    endtask
    initial begin
        errors=0; head=0; tail=0; count=0;
        rst=1; wr_en=0; rd_en=0; wdata=0;
        @(posedge clk); #1; check_flags("after reset");
        rst=0;
        // fill it up: write 10 times (only 8 should succeed)
        for (i=0;i<10;i=i+1) begin
            wr_en=1; rd_en=0; wdata=i[7:0]+8'h10;
            @(posedge clk); #1;
            if (count<8) begin model_q[tail]=wdata; tail=(tail+1)%32; count=count+1; end
            check_flags("during fill");
        end
        wr_en=0;
        // now drain: read 10 times (only 8 valid, rest should not change count below 0)
        // rdata is combinational off the current (pre-edge) head pointer, so sample it
        // BEFORE asserting rd_en's clock edge, not after (the pointer advances ON that edge).
        for (i=0;i<10;i=i+1) begin
            if (count>0 && rdata !== model_q[head]) begin
                errors=errors+1;
                $display("MISMATCH drain %0d rdata=%b expected=%b", i, rdata, model_q[head]);
            end
            rd_en=1;
            @(posedge clk); #1;
            if (count>0) begin head=(head+1)%32; count=count-1; end
            check_flags("during drain");
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
