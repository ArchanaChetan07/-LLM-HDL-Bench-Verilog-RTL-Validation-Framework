`timescale 1ns/1ps
module tb_bcd_adder;
    reg [3:0] a,b; reg cin; wire [3:0] sum; wire cout;
    integer i,j,c,errors=0;
    reg [4:0] bin; reg exp_cout; reg [3:0] exp_sum;
    bcd_adder dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    initial begin
        errors=0;
        for (i=0;i<10;i=i+1) for (j=0;j<10;j=j+1) for (c=0;c<2;c=c+1) begin
            a=i[3:0]; b=j[3:0]; cin=c[0];
            #1;
            bin = a+b+cin;
            if (bin > 9) begin exp_sum = (bin+6) & 5'hF; exp_cout=1; end
            else begin exp_sum = bin[3:0]; exp_cout=0; end
            if (sum !== exp_sum || cout !== exp_cout) begin
                errors=errors+1;
                $display("MISMATCH a=%d b=%d cin=%b sum=%d cout=%b expected_sum=%d expected_cout=%b", a,b,cin,sum,cout,exp_sum,exp_cout);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
