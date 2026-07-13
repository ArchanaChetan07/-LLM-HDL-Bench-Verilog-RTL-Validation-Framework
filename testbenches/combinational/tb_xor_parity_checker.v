`timescale 1ns/1ps
module tb_xor_parity_checker;
    reg [7:0] data; reg parity_bit; wire error;
    integer i, p, errors=0;
    reg exp;
    xor_parity_checker dut(.data(data), .parity_bit(parity_bit), .error(error));
    initial begin
        errors=0;
        for (i=0;i<256;i=i+8) for (p=0;p<2;p=p+1) begin
            data=i[7:0]; parity_bit=p[0];
            #1;
            exp = ^{parity_bit, data};
            if (error !== exp) begin
                errors=errors+1;
                $display("MISMATCH data=%b parity_bit=%b error=%b expected=%b", data, parity_bit, error, exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
