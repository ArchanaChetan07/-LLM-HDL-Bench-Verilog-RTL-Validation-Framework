`timescale 1ns/1ps
module tb_decoder3to8;
    reg [2:0] in; reg en; wire [7:0] out;
    integer i, e, errors=0;
    reg [7:0] exp;
    decoder3to8 dut(.in(in), .en(en), .out(out));
    initial begin
        errors=0;
        for (i=0;i<8;i=i+1) for (e=0;e<2;e=e+1) begin
            in=i[2:0]; en=e[0];
            #1;
            exp = en ? (8'b1 << in) : 8'b0;
            if (out !== exp) begin
                errors=errors+1;
                $display("MISMATCH in=%b en=%b out=%b expected=%b", in, en, out, exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
