`timescale 1ns/1ps
module tb_ripple_carry_adder4;
    reg [3:0] a,b; reg cin; wire [3:0] sum; wire cout;
    integer i,j,c,errors=0;
    reg [4:0] exp;
    ripple_carry_adder4 dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) for (j=0;j<16;j=j+1) for (c=0;c<2;c=c+1) begin
            a=i[3:0]; b=j[3:0]; cin=c[0];
            #1;
            exp = a+b+cin;
            if ({cout,sum} !== exp) begin
                errors=errors+1;
                $display("MISMATCH a=%d b=%d cin=%b sum=%d cout=%b expected=%d", a,b,cin,sum,cout,exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
