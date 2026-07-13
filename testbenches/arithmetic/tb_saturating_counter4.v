`timescale 1ns/1ps
module tb_saturating_counter4;
    reg clk=0, rst, en; wire [3:0] count;
    integer errors=0, i;
    reg [3:0] model;
    saturating_counter4 dut(.clk(clk), .rst(rst), .en(en), .count(count));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; en=0; @(posedge clk); #1; model=0;
        if (count!==0) begin errors=errors+1; $display("MISMATCH after reset"); end
        rst=0;
        for (i=0;i<20;i=i+1) begin
            en=1; @(posedge clk); #1;
            if (model != 4'b1111) model = model+1;
            if (count!==model) begin errors=errors+1; $display("MISMATCH i=%0d count=%d exp=%d",i,count,model); end
        end
        // hold with en=0
        en=0; @(posedge clk); #1;
        if (count!==model) begin errors=errors+1; $display("MISMATCH hold count=%d exp=%d",count,model); end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
