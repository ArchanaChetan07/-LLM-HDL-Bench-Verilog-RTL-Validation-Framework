`timescale 1ns/1ps
module tb_subtractor4bit_2comp;
    reg [3:0] a,b; wire [3:0] diff; wire borrow;
    integer i,j,errors=0;
    reg [3:0] exp_diff; reg exp_borrow;
    subtractor4bit_2comp dut(.a(a),.b(b),.diff(diff),.borrow(borrow));
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) for (j=0;j<16;j=j+1) begin
            a=i[3:0]; b=j[3:0];
            #1;
            exp_diff = a - b;
            exp_borrow = (a<b);
            if (diff!==exp_diff || borrow!==exp_borrow) begin
                errors=errors+1;
                $display("MISMATCH a=%d b=%d diff=%d borrow=%b exp_diff=%d exp_borrow=%b",a,b,diff,borrow,exp_diff,exp_borrow);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
