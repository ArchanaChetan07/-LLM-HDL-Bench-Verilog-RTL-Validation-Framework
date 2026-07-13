`timescale 1ns/1ps
module tb_sign_magnitude_adder4;
    reg sign_a, sign_b; reg [2:0] mag_a, mag_b;
    wire sign_result; wire [2:0] mag_result; wire overflow;
    integer sa, sb, ma, mb, errors=0;
    reg exp_sign, exp_of; reg [2:0] exp_mag; reg [3:0] sum4;
    sign_magnitude_adder4 dut(.sign_a(sign_a), .mag_a(mag_a), .sign_b(sign_b), .mag_b(mag_b),
                               .sign_result(sign_result), .mag_result(mag_result), .overflow(overflow));
    initial begin
        errors=0;
        for (sa=0;sa<2;sa=sa+1) for (sb=0;sb<2;sb=sb+1) for (ma=0;ma<8;ma=ma+1) for (mb=0;mb<8;mb=mb+1) begin
            sign_a=sa[0]; sign_b=sb[0]; mag_a=ma[2:0]; mag_b=mb[2:0];
            #1;
            if (sa==sb) begin
                sum4 = ma+mb;
                exp_of = (sum4>7);
                exp_mag = sum4[2:0];
                exp_sign = sa[0];
            end else begin
                exp_of = 0;
                if (ma>=mb) begin exp_mag = ma-mb; exp_sign = (ma==mb)?1'b0:sa[0]; end
                else begin exp_mag = mb-ma; exp_sign = sb[0]; end
            end
            if (sign_result!==exp_sign || mag_result!==exp_mag || overflow!==exp_of) begin
                errors=errors+1;
                $display("MISMATCH sa=%b sb=%b ma=%d mb=%d sign=%b mag=%d of=%b exp_sign=%b exp_mag=%d exp_of=%b",
                          sa,sb,ma,mb,sign_result,mag_result,overflow,exp_sign,exp_mag,exp_of);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
