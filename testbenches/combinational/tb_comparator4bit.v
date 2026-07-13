`timescale 1ns/1ps
module tb_comparator4bit;
    reg [3:0] a,b; wire gt,eq,lt;
    integer i,j,errors=0;
    comparator4bit dut(.a(a),.b(b),.gt(gt),.eq(eq),.lt(lt));
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) for (j=0;j<16;j=j+1) begin
            a=i[3:0]; b=j[3:0];
            #1;
            if (gt !== (a>b) || eq !== (a==b) || lt !== (a<b)) begin
                errors=errors+1;
                $display("MISMATCH a=%d b=%d gt=%b eq=%b lt=%b", a, b, gt, eq, lt);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
