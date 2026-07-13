`timescale 1ns/1ps
module tb_full_adder1bit;
    reg a,b,cin; wire sum,cout;
    integer i,errors=0;
    reg exp_sum, exp_cout;
    full_adder1bit dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    initial begin
        errors=0;
        for (i=0;i<8;i=i+1) begin
            {a,b,cin} = i[2:0];
            #1;
            exp_sum = a^b^cin;
            exp_cout = (a&b)|(a&cin)|(b&cin);
            if (sum!==exp_sum || cout!==exp_cout) begin
                errors=errors+1;
                $display("MISMATCH a=%b b=%b cin=%b sum=%b cout=%b exp_sum=%b exp_cout=%b", a,b,cin,sum,cout,exp_sum,exp_cout);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
