`timescale 1ns/1ps
module tb_majority_vote3;
    reg a,b,c; wire majority;
    integer i,errors=0;
    reg exp;
    majority_vote3 dut(.a(a),.b(b),.c(c),.majority(majority));
    initial begin
        errors=0;
        for (i=0;i<8;i=i+1) begin
            {a,b,c} = i[2:0];
            #1;
            exp = (a&b)|(a&c)|(b&c);
            if (majority !== exp) begin
                errors=errors+1;
                $display("MISMATCH a=%b b=%b c=%b majority=%b expected=%b", a,b,c,majority,exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
