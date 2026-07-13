`timescale 1ns/1ps
module tb_multiplier4x4_shiftadd;
    reg [3:0] a,b; wire [7:0] product;
    integer i,j,errors=0;
    multiplier4x4_shiftadd dut(.a(a),.b(b),.product(product));
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) for (j=0;j<16;j=j+1) begin
            a=i[3:0]; b=j[3:0];
            #1;
            if (product !== (a*b)) begin
                errors=errors+1;
                $display("MISMATCH a=%d b=%d product=%d expected=%d", a,b,product,a*b);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
