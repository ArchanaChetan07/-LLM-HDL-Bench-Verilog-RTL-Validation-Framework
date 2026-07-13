`timescale 1ns/1ps
module tb_bin_to_bcd_2digit;
    reg [7:0] bin; wire [3:0] tens, ones;
    integer i,errors=0;
    bin_to_bcd_2digit dut(.bin(bin),.tens(tens),.ones(ones));
    initial begin
        errors=0;
        for (i=0;i<100;i=i+1) begin
            bin=i[7:0];
            #1;
            if (tens !== (i/10) || ones !== (i%10)) begin
                errors=errors+1;
                $display("MISMATCH bin=%d tens=%d ones=%d exp_tens=%d exp_ones=%d", bin,tens,ones,i/10,i%10);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
